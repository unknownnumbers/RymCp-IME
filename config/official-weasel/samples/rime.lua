-- RymCp Chinese and smart English for official Weasel.
official_backup_mode = require('official_backup_mode')
draft_limit = require('draft_limit')
cn_translator = require('cn_translator')
en_processor = require('en_processor')
en_segmentor = require('en_segmentor')
candidate_keys = require('candidate_keys')
select_hanzi = require('select_hanzi')

function research_mode_filter(input, env)
  local english = env.engine.context:get_option('research_english')
  for candidate in input:iter() do
    if not english or candidate.type == 'research_english' then yield(candidate) end
  end
end

-- Preserve mode-specific labels in the fixed vertical candidate list.
local comment_labels = {
  ['完整词'] = '整', ['原文'] = '原', ['纠错'] = '糾', ['补全'] = '補',
  ['笔画'] = '筆', ['拆字'] = '拆', ['简拼'] = '略',
}
function candidate_comment_filter(input, env)
  local english = env.engine.context:get_option('research_english')
  local seen={}
  for candidate in input:iter() do
    local comment = candidate.comment
    if comment ~= '' then
      comment = comment:gsub('%S+', comment_labels)
      comment = english and (' | ' .. comment) or (' (' .. comment .. ')')
    end
    local genuine = candidate
    while genuine:get_dynamic_type() == 'Shadow' or genuine:get_dynamic_type() == 'Uniquified' do
      genuine = genuine:get_genuine()
    end
    local shown_type = candidate.type == 'mdx_sc_original' and genuine.type or candidate.type
    local shown = ShadowCandidate(genuine, shown_type, candidate.text, comment)
    shown.start, shown._end, shown.quality = candidate.start, candidate._end, candidate.quality
    local cp=#candidate.text>0 and utf8.codepoint(candidate.text)
    local hanzi=cp and ((cp>=0x3400 and cp<=0x9fff) or (cp>=0xf900 and cp<=0xfaff)
      or (cp>=0x20000 and cp<=0x3347f))
    local key=hanzi and (candidate.text..'\t'..candidate.start..':'..candidate._end)
    if not key or not seen[key] then
      if key then seen[key]=true end
      yield(shown)
    end
  end
end
