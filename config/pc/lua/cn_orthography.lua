-- Explicit single-character selection follows MDX senses and canonical codes.
-- Called after Chinese ranking, with the code already decoded by its owner.
local M = {}
local retained = {
  ['乾']={qian=true}, ['剋']={kei=true}, ['吒']={zha=true},
  ['夥']={huo=true}, ['徵']={zhi=true}, ['於']={yu=true,wu=true},
  ['昇']={sheng=true}, ['氾']={fan=true}, ['甦']={su=true},
  ['甯']={ning=true}, ['祕']={bi=true,mi=true}, ['脩']={xiu=true},
  ['苧']={}, ['蒐']={sou=true}, ['釐']={xi=true},
  ['陞']={sheng=true}, ['麽']={mo=true},
}
local ordinary_sc = {
  ['乾']='干', ['剋']='克', ['吒']='咤', ['夥']='伙', ['徵']='征',
  ['於']='于', ['昇']='升', ['氾']='泛', ['甦']='苏', ['甯']='宁',
  ['祕']='秘', ['脩']='修', ['苧']='苎', ['蒐']='搜', ['釐']='厘',
  ['陞']='升', ['麽']='么',
}
function M.key(text, code, sc)
  if not sc then return text, false end
  local readings = retained[text]
  if readings then
    if not readings[code] then text = ordinary_sc[text] end
    return text, true
  elseif text == '麼' then
    return code == 'mo' and '麽' or '么', true
  elseif text == '噁' and code == 'wu' then
    return '恶', true
  else
    -- Keep existing 噁/蘋 multivalue candidates and their native learning.
    return text, false
  end
end
function M.apply(candidate, code, sc)
  local text, handled = M.key(candidate.text, code, sc)
  if not handled then return candidate end
  local shown_type = 'mdx_sc_original'
  local shown = ShadowCandidate(candidate, shown_type, text, candidate.comment)
  shown.start, shown._end, shown.quality = candidate.start, candidate._end, candidate.quality
  return shown
end
return M
