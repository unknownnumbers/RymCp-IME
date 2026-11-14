-- SPDX-License-Identifier: GPL-3.0-only
local index = require('en_index')
local packages = require('rymcp_dlc')
local M = {}
local function identity(record) return record.code .. '\t' .. record.word end

function M.load(vocab, extensions, engine)
  local snapshot = packages.modules(engine)
  local aliases, words, owners, ordinary, base = {}, {}, {}, {}, {}
  for _, alias in ipairs(extensions.words) do
    for _, record in ipairs(extensions.aliases[alias]) do
      local key = identity(record)
      if not base[key] then base[key] = record end
    end
  end
  -- Package order is fixed by the package loader. The first definition owns
  -- a shared identity; additional aliases never add corpus counts.
  for _, package in ipairs(snapshot) do
    if package.languages.en and package.files['english.tsv'] then
      local records = package.english
      if records then
        for _, record in ipairs(records) do
          record.optional = true
          local key = identity(record)
          local owner = owners[key]
          if not owner then
            local original = base[key]
            if vocab.frequency[record.word] and record.code == record.word then
              owner = {code=record.code, word=record.word, shown=extensions.display[record.word],
                frequency=vocab.frequency[record.word], expansion=0}
            else
              owner = original or record
            end
            owners[key] = owner
          end
          if not aliases[record.alias] then aliases[record.alias] = {}; words[#words + 1] = record.alias end
          local group = aliases[record.alias]
          local duplicate = false
          for _, prior in ipairs(group) do if identity(prior) == key then duplicate = true; break end end
          if not duplicate then
            group[#group + 1] = {code=owner.code, word=owner.word, shown=owner.shown,
              frequency=owner.frequency, expansion=record.expansion, parent=record.parent,
              optional=owner.optional}
          end
          if not base[key] and not vocab.frequency[record.word] and owner.ordinary then
            ordinary[record.word] = true
          end
        end
      end
    end
  end
  table.sort(words)
  return {aliases=aliases, words=words, ordinary=ordinary, index=index.from_words(words), catalog=snapshot}
end

return M
