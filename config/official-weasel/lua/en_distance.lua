-- Unrestricted Damerau-Levenshtein distance, ASCII words only.
local function distance(a, b)
  local m, n, inf = #a, #b, #a + #b
  local d, last = {}, {}
  for i = 0, m + 1 do d[i] = {} end
  d[0][0] = inf
  for i = 0, m do d[i + 1][0], d[i + 1][1] = inf, i end
  for j = 0, n do d[0][j + 1], d[1][j + 1] = inf, j end
  for i = 1, m do
    local previous_match = 0
    for j = 1, n do
      local ai, bj = a:sub(i,i), b:sub(j,j)
      local previous_i, previous_j = last[bj] or 0, previous_match
      local cost = 1
      if ai == bj then cost, previous_match = 0, j end
      d[i + 1][j + 1] = math.min(
        d[i][j] + cost, d[i + 1][j] + 1, d[i][j + 1] + 1,
        d[previous_i][previous_j] + (i - previous_i - 1) + 1 + (j - previous_j - 1))
    end
    last[a:sub(i,i)] = i
  end
  return d[m + 1][n + 1]
end
return distance
