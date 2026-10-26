-- Adapted to the local segment model from Ice's select_character.lua idea.
-- Upstream: BlindingDark/rime-lua-select-character; iDvel/rime-ice (GPL-3.0).
-- Unlike the original text substitution, use segment offsets to preserve raw tails.
local M = {}

local function han(cp)
  return cp == 0x3007 or (cp >= 0x3400 and cp <= 0x4dbf)
      or (cp >= 0x4e00 and cp <= 0x9fff) or (cp >= 0xf900 and cp <= 0xfaff)
      or (cp >= 0x20000 and cp <= 0x2fa1f) or (cp >= 0x30000 and cp <= 0x3347f)
end

function M.func(key, env)
  local ctx = env.engine.context
  if ctx:get_option('research_english') or ctx:get_option('ascii_mode')
      or key:release() or key:ctrl() or key:alt() or key:super()
      or (key.keycode ~= 0x5b and key.keycode ~= 0x5d) then return 2 end
  local candidate = ctx:get_selected_candidate()
  if not candidate then return 2 end
  local kind = candidate:get_genuine().type
  if kind:match('^u_') or kind:match('^tool_') then return 2 end
  local first, last
  for _, cp in utf8.codes(candidate.text) do
    if han(cp) then first = first or cp; last = cp end
  end
  if not first then return 2 end
  local text = utf8.char(key.keycode == 0x5b and first or last)
  local before = {}
  for _, seg in ipairs(ctx.composition:toSegmentation():get_segments()) do
    if seg._end > candidate.start then break end
    local prior = seg:get_selected_candidate()
    before[#before + 1] = prior and prior.text or ctx.input:sub(seg.start + 1, seg._end)
  end
  local tail = ctx.input:sub(candidate._end + 1)
  env.engine:commit_text(table.concat(before) .. text)
  ctx:clear()
  if tail ~= '' then ctx:push_input(tail) end
  return 1
end

return M
