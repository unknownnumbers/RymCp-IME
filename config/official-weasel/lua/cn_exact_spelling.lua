-- SPDX-License-Identifier: GPL-3.0-only
-- Explicit complete-syllable constraints. All positions are original raw bytes.
local M = {}

function M.parse(input)
  if not input:find('"', 1, true) then return nil end
  local plan = {input=input, locks={}, closing={}}
  local first = 1
  for position = 1, #input do
    local character = input:sub(position, position)
    if character == '"' then
      local lock = {first=first, last=position-1, closing=position}
      plan.locks[#plan.locks+1] = lock
      plan.closing[position] = lock
      first = position+1
    elseif character == "'" or character == ' ' then
      first = position+1
    end
  end
  return plan
end

-- Prefix-free atoms have exactly as many bytes as spelling plus its quote.
-- Only the generated kind-0 aliases exist in the native spelling prism.
function M.atom(spelling)
  return '@' .. spelling:sub(1, -2):upper() .. spelling:sub(-1)
end

function M.encode(input, free)
  free = free or function(value) return value end
  local result, position = {}, 1
  while true do
    local first, last, spelling = input:find('([a-z]+)"', position)
    if not first then
      result[#result+1] = free(input:sub(position))
      break
    end
    result[#result+1] = free(input:sub(position, first-1))
    result[#result+1] = M.atom(spelling)
    position = last+1
  end
  return table.concat(result)
end

function M.unmarked(plan, first, last)
  if not plan then return true end
  for _, lock in ipairs(plan.locks) do
    if first <= lock.closing and last >= lock.first then return false end
  end
  return true
end

-- A matching syllable may touch a locked block only by consuming that entire
-- block with an existing normal full spelling. Its quote belongs to the edge.
function M.advance(plan, first, length, kind)
  local last = first+length-1
  for _, lock in ipairs(plan.locks) do
    if first <= lock.closing and last >= lock.first then
      if first ~= lock.first or last ~= lock.last or kind ~= 0 then return nil end
    end
  end
  local following = last+1
  while true do
    local character = plan.input:sub(following, following)
    if character == '"' then
      local lock = plan.closing[following]
      if not lock or first ~= lock.first or last ~= lock.last or kind ~= 0 then return nil end
    elseif character ~= "'" and character ~= ' ' then
      break
    end
    following = following+1
  end
  return following
end

return M
