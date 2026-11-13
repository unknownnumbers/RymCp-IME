-- Limit only pending Chinese or smart-English spelling. Selection and editing
-- remain available at the limit, and confirmed segments keep their raw codes.
local M = {}
local defaults = {chinese=48, english=64}

function M.allow_context(ctx, schema, character)
  local mode = ctx:get_option('research_english') and 'english' or 'chinese'
  local limit = schema.config:get_int('draft_limits/' .. mode) or defaults[mode]
  local confirmed = ctx.composition:toSegmentation():get_confirmed_position()
  local start = math.min(confirmed, ctx.caret_pos)
  return #ctx.input + #character - start <= limit
end

function M.init(env)
  local config = env.engine.schema.config
  env.spelling = (config:get_string('speller/alphabet') or '')
      .. (config:get_string('speller/delimiter') or '')
end

function M.func(key, env)
  local ctx = env.engine.context
  if key:release() or key:ctrl() or key:alt() or key:super()
      or ctx:get_option('ascii_mode') then return 2 end
  local code = key.keycode
  if code < 0x21 or code > 0x7e then return 2 end
  local character = string.char(code)
  -- candidate_keys decides whether '-' inserts or navigates, and applies
  -- this same allowance only when it inserts.
  if character == '-' then return 2 end
  local spelling = env.spelling:find(character, 1, true) ~= nil
      or (ctx:get_option('research_english') and character == "'")
  if not spelling then return 2 end
  return M.allow_context(ctx, env.engine.schema, character) and 2 or 1
end

return M
