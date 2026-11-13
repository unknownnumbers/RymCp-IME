-- Chinese suffix costs retained for candidate boundaries.
local M = {}
function M.normal_tail_cost(input, env, cache)
  if cache.tail_cost then return cache.tail_cost end
  local costs, following, counts = {[#input + 1]=0}, {}, {[#input + 1]=0}
  for position = #input, 1, -1 do
    local best
    local best_next, best_count
    for length = 1, math.min(env.normal_max_length, #input - position + 1) do
      local kind = env.normal_spellings[input:sub(position, position + length - 1)]
      if kind then
        local next_position = position + length
        while input:sub(next_position, next_position) == "'"
            or input:sub(next_position, next_position) == ' ' do next_position = next_position + 1 end
        local tail = costs[next_position]
        if tail then
          local cost = kind + tail
          local count = counts[next_position] and counts[next_position] + 1
          if best == nil or cost < best then
            best, best_next, best_count = cost, count and next_position, count
          elseif cost == best and count and (not best_count or count < best_count
              or (count == best_count and next_position > best_next)) then
            best_next, best_count = next_position, count
          end
        end
      end
    end
    costs[position], following[position], counts[position] = best, best_next, best_count
  end
  cache.tail_cost, cache.tail_next, cache.tail_count = costs, following, counts
  return costs
end

local owner_property = 'rymcp_official_decoder_owner'
local next_owner, owners = 0, {}

-- Each Context borrows its own active translator's dictionary-only Memory.
function M.init(env)
  next_owner = next_owner + 1
  env.official_decoder_owner = tostring(next_owner)
  owners[env.official_decoder_owner] = env
  env.engine.context:set_property(owner_property, env.official_decoder_owner)
end

function M.decoder(ctx)
  local env = owners[ctx:get_property(owner_property)]
  return env and env.decoder
end

function M.fini(env)
  local owner = env.official_decoder_owner
  if not owner then return end
  owners[owner] = nil
  local ctx = env.engine.context
  if ctx:get_property(owner_property) == owner then
    ctx:set_property(owner_property, '')
  end
  env.official_decoder_owner = nil
end
function M.record(env, input, start, cache) end
function M.refresh(ctx) end
return M
