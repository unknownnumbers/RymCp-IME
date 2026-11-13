-- Official librime-lua adapter. Left Shift changes the lookup mode only;
-- native ascii_composer owns Right Shift and Caps Lock.
local M = {}

function M.init(env)
  env.shift_down, env.shift_used = false, false
  env.option_connection = env.engine.context.option_update_notifier:connect(function(ctx, name)
    if name == 'ascii_mode' and ctx:get_option('ascii_mode') then
      ctx:set_option('research_english', false)
    elseif name == 'research_english' and ctx:get_option('research_english') then
      ctx:set_option('ascii_mode', false)
    end
  end)
end

function M.fini(env)
  env.option_connection:disconnect()
end

function M.func(key, env)
  if key.keycode ~= 0xffe1 then
    if env.shift_down then env.shift_used = true end
    return 2
  end
  if not key:release() then
    -- Modifiers and other keys cancel the tap. Repeat keydown cannot make a
    -- chord into a tap; every Shift release retires the pending gesture.
    if not env.shift_down then env.shift_used = key:ctrl() or key:alt() or key:super() end
    env.shift_down = true
    return 0
  end
  local toggle = env.shift_down and not env.shift_used
      and not (key:ctrl() or key:alt() or key:super())
  env.shift_down, env.shift_used = false, false
  if toggle then
    local ctx = env.engine.context
    ctx:set_option('research_english', not ctx:get_option('research_english'))
    return 1
  end
  return 0
end

return M
