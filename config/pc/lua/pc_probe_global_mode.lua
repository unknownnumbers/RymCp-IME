-- Same-process coordinator; no schema switching or persistent mode file.
local M = {}
local G = {next_id=0, records={}, values={research_english=false, simplification=true},
           busy=false, held_printable={}, key_sequence=0}

-- ToUnicodeEx may report '+' on keydown but '=' after Shift is released.
-- Pair the two ASCII symbols of the same QWERTY key, and letter case.
local shifted = [=[~!@#$%^&*()_+{}|:"<>?]=]
local unshifted = [=[`1234567890-=[]\;',./]=]
local base_key = {}
for i = 1, #shifted do base_key[shifted:byte(i)] = unshifted:byte(i) end
local function printable_key(code)
  if code < 0x20 or code > 0x7e then return nil end
  if code >= 0x41 and code <= 0x5a then return code + 0x20 end
  return base_key[code] or code
end

-- This property exists only during the current frontend process_key request.
-- Missing/legacy/invalid data cannot prove that a physically held key is up.
local function physical_shift(ctx, key)
  local encoded = ctx:get_property('weasel_shift_snapshot') or ''
  local digits, message, vkey, info = encoded:match('^v1:(%d+):(%d+):(%d+):(%d+)$')
  local flags = digits and tonumber(digits)
  if not flags or flags < 0 or flags > 31 or (flags & 1) == 0 then return nil end
  if #message > 10 or #vkey > 10 or #info > 10 then return nil end
  local mt, vk, ki = tonumber(message), tonumber(vkey), tonumber(info)
  if mt > 0xffffffff or ki > 0xffffffff or
      (vk ~= 0x10 and vk ~= 0xa0 and vk ~= 0xa1) then return nil end
  local left, right = (flags & 4) ~= 0, (flags & 8) ~= 0
  local own = key.keycode == 0xffe1 and left or key.keycode == 0xffe2 and right
  if own == key:release() or (key:release() and (flags & 16) ~= 0) then return nil end
  return {left=left, right=right, printable=(flags & 2) ~= 0,
          repeated=(flags & 16) ~= 0, id=message .. ':' .. vkey .. ':' .. info}
end

local function cancel_shift_tap(owner)
  if not owner then return end
  owner.shift_key, owner.shift_sequence = nil, nil
  owner.shift_blocked = true
end

local function apply_page_size(record)
  if not record.chinese_page_size or not record.english_page_size then return end
  local size = record.context:get_option('research_english')
               and record.english_page_size or record.chinese_page_size
  record.schema.page_size = size
  if record.schema.page_size ~= size then
    error('Mode pagination requires the matching patched librime-lua build')
  end
end

local function sync(record)
  for name, value in pairs(G.values) do
    if record.context:get_option(name) ~= value then
      record.context:set_option(name, value)
    end
  end
  apply_page_size(record)
end

local function guarded(fn)
  G.busy = true
  local ok, error_message = pcall(fn)
  G.busy = false
  if not ok then error(error_message) end
end

local function arm(record)
  if record.armed then return end
  guarded(function() sync(record) end)
  record.armed = true
end

function M.init(env)
  G.next_id = G.next_id + 1
  local record = {id=G.next_id, context=env.engine.context, alive=true, armed=false}
  record.schema = env.engine.schema
  record.chinese_page_size = record.schema.config:get_int('menu/chinese_page_size')
  record.english_page_size = record.schema.config:get_int('menu/english_page_size')
  env.record = record
  G.records[record.id] = record
  env.connection = record.context.option_update_notifier:connect(function(context, name)
    if record.alive and name == 'ascii_mode' and context:get_option('ascii_mode')
        and context:get_option('research_english') then
      context:set_option('research_english', false)
    elseif record.alive and name == 'research_english' and context:get_option('research_english')
        and context:get_option('ascii_mode') then
      context:set_option('ascii_mode', false)
    end
    if name == 'research_english' and record.alive then apply_page_size(record) end
    if name == 'probe_options_ready' and record.alive and not record.armed then
      arm(record)
      return
    end
    if G.busy or not record.alive or not record.armed or G.values[name] == nil then return end
    local value = context:get_option(name)
    if G.values[name] == value then return end
    G.values[name] = value
    guarded(function()
      for _, peer in pairs(G.records) do
        if peer.alive and peer.armed then sync(peer) end
      end
    end)
  end)
end

function M.fini(env)
  if G.shift_owner == env then
    cancel_shift_tap(env)
    G.shift_owner = nil
  end
  if G.physical_gesture and G.physical_gesture.owner == env then
    G.physical_gesture = nil
  end
  local record = env.record
  if record then
    record.alive = false
    G.records[record.id] = nil
  end
  if env.connection then env.connection:disconnect() end
  env.connection, env.record = nil, nil
end

function M.func(key, env)
  -- Replay a validated right-Shift tap through the native inline_ascii handler.
  if env.native_shift then return 2 end
  arm(env.record)
  local ctx = env.record.context
  local shift = key.keycode == 0xffe1 or key.keycode == 0xffe2
  if not shift then
    G.key_sequence = G.key_sequence + 1
    if G.physical_gesture then
      G.physical_gesture.blocked = true
      cancel_shift_tap(G.physical_gesture.owner)
    end
    local code = printable_key(key.keycode)
    if code then
      if key:release() then G.held_printable[code] = nil
      elseif (key.modifier & 0x4c) == 0 then G.held_printable[code] = true end
    end
  end
  env.held_shift = env.held_shift or {}
  if shift then
    local physical = physical_shift(ctx, key)
    local gesture = G.physical_gesture
    if not key:release() and physical and not physical.repeated and gesture
        and gesture.id == physical.id and gesture.key == key.keycode then
      -- Repeated Test/Key callbacks for this message cannot clear a chord or
      -- move its owner, even when another context received the duplicate.
      local other = key.keycode == 0xffe1 and physical.right or
                    key.keycode == 0xffe2 and physical.left
      gesture.blocked = gesture.blocked or physical.printable or other
                        or (key.modifier & 0x4c) ~= 0
      if gesture.blocked then cancel_shift_tap(gesture.owner) end
      return 0
    end
    local cross_owner = G.shift_owner and G.shift_owner ~= env
    if cross_owner then
      -- A release in another context may cancel A, never commit a tap in B.
      cancel_shift_tap(G.shift_owner)
      G.shift_owner = nil
      G.physical_gesture = nil
    end
    if not key:release() then
      if physical and not physical.repeated then
        -- Only a valid fresh down can retire a missing-up candidate and repair
        -- a stale printable record. Repeat and unknown data cannot rearm it.
        cancel_shift_tap(G.shift_owner)
        env.held_shift = {}
        if physical.left then env.held_shift[0xffe1] = true end
        if physical.right then env.held_shift[0xffe2] = true end
        if not physical.printable then G.held_printable = {} end
        env.shift_key = key.keycode
        env.shift_sequence = G.key_sequence
        local other = key.keycode == 0xffe1 and physical.right or
                      key.keycode == 0xffe2 and physical.left
        env.shift_blocked = (key.modifier & 0x4c) ~= 0 or physical.printable or other
        G.physical_gesture = {owner=env, id=physical.id, key=key.keycode,
                              blocked=env.shift_blocked}
      elseif physical and physical.repeated then
        local existing = G.shift_owner == env and env.shift_key == key.keycode
                         and env.held_shift[key.keycode]
        if not existing then env.shift_key = nil end
        local other = key.keycode == 0xffe1 and physical.right or
                      key.keycode == 0xffe2 and physical.left
        env.shift_blocked = env.shift_blocked or not existing or physical.printable
                            or other or (key.modifier & 0x4c) ~= 0
        if G.physical_gesture then
          G.physical_gesture.blocked = G.physical_gesture.blocked or env.shift_blocked
        end
      elseif next(env.held_shift) then
        env.shift_key, env.shift_blocked = nil, true
      else
        env.shift_key = key.keycode
        env.shift_sequence = G.key_sequence
        env.shift_blocked = (key.modifier & 0x4c) ~= 0
                            or next(G.held_printable) ~= nil or cross_owner
      end
      env.held_shift[key.keycode] = true
      G.shift_owner = env
    else
      local toggle = env.shift_key == key.keycode and not env.shift_blocked
                     and env.shift_sequence == G.key_sequence
                     and (key.modifier & 0x4c) == 0
                     and not cross_owner
      if gesture then
        toggle = toggle and gesture.owner == env and not gesture.blocked and physical ~= nil
      end
      if physical then
        toggle = toggle and not physical.printable and not physical.left and not physical.right
      end
      env.held_shift[key.keycode], env.shift_key = nil, nil
      env.shift_blocked = next(env.held_shift) ~= nil
      if G.shift_owner == env then G.shift_owner = nil end
      G.physical_gesture = nil
      if toggle then
        if key.keycode == 0xffe1 then
          ctx:set_option('research_english', not ctx:get_option('research_english'))
        else
          env.native_shift = true
          env.engine:process_key(KeyEvent(0xffe2, 0))
          env.engine:process_key(KeyEvent(0xffe2, 0x40000000))
          env.native_shift = false
        end
        return 1
      end
    end
    -- Leave physical modifier events to the application, without a second tracker.
    return 0
  else
    -- A release also proves that Shift overlapped another key.
    env.shift_key = nil
    if next(env.held_shift) then env.shift_blocked = true end
  end
  return 2
end
return M
