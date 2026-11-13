-- SPDX-License-Identifier: GPL-3.0-only
-- Optional modules are read only from the user directory, as complete units.
local M = {}
local ids = {'math', 'physics', 'computer', 'poetry'}
local known = {}
for _, id in ipairs(ids) do known[id] = true end
local MAX_FILE = 32 * 1024 * 1024

local function read_file(path, limit)
  local file = io.open(path, 'rb')
  if not file then return nil end
  local data = file:read(limit + 1)
  file:close()
  if not data or #data > limit then return nil end
  return data
end

local function adler32(data)
  local a, b = 1, 0
  for offset = 1, #data, 5552 do
    for i = offset, math.min(offset + 5551, #data) do
      a = a + data:byte(i)
      b = b + a
    end
    a, b = a % 65521, b % 65521
  end
  return string.format('%08x', b * 65536 + a)
end
M.adler32 = adler32

local function lines(data)
  return (data .. '\n'):gmatch('(.-)\n')
end

local function safe_relative(path)
  if not path:match('^[A-Za-z0-9_./%-]+$') or path:sub(1, 1) == '/'
      or path:sub(-1) == '/' or path:find('//', 1, true) then return false end
  for part in path:gmatch('[^/]+') do
    if part == '.' or part == '..' then return false end
  end
  return true
end

local function parse_manifest(data, id)
  if data:sub(-1) ~= '\n' then return nil end
  local metadata, entries = {}, {}
  for raw in lines(data) do
    local line = raw:gsub('\r$', '')
    if line ~= '' then
      local key, value = line:match('^([a-z]+)\t([^\t]+)$')
      if key and key ~= 'file' then
        if metadata[key] or (key ~= 'format' and key ~= 'id'
            and key ~= 'revision' and key ~= 'languages') then return nil end
        metadata[key] = value
      else
        local path, size, checksum = line:match('^file\t([^\t]+)\t(%d+)\t([0-9a-f]+)$')
        size = tonumber(size)
        if not path or not safe_relative(path) or entries[path] or path == 'manifest.tsv'
            or not size or size < 1 or size > MAX_FILE or #checksum ~= 8 then return nil end
        entries[path] = {size=size, checksum=checksum}
      end
    end
  end
  if metadata.format ~= '1' or metadata.id ~= id or not metadata.revision
      or not metadata.revision:match('^[A-Za-z0-9][A-Za-z0-9_.%-]*$') then return nil end
  local languages = {}
  if metadata.languages == 'cn' then languages.cn = true
  elseif metadata.languages == 'en' then languages.en = true
  elseif metadata.languages == 'cn,en' then languages.cn, languages.en = true, true
  else return nil end
  if (not not languages.cn) ~= (entries['words.dict.yaml'] ~= nil)
      or (not not languages.en) ~= (entries['english.tsv'] ~= nil) then return nil end
  return {id=id, revision=metadata.revision, languages=languages, entries=entries}
end

local function read_cn(data, path, module, leaf, needs_patch)
  local _, body_start = data:find('\n%.%.%.\r?\n')
  if not body_start or data:sub(-1) ~= '\n' then return false end
  local config = Config()
  if not config:load_from_file(path)
      or config:get_string('name') ~= 'rymcp_dlc/' .. module.id .. '/' .. leaf
      or config:get_string('version') ~= module.revision
      or config:get_string('sort') ~= 'by_weight'
      or config:get_bool('use_preset_vocabulary') ~= false
      or config:get_item('import_tables') or config:get_item('encoder')
      or config:get_item('columns') or config:get_item('vocabulary') then return false end
  if not needs_patch and config:get_item('patch') then return false end
  local seen, count = {}, 0
  for raw in lines(data:sub(body_start + 1)) do
    local line = raw:gsub('\r$', '')
    if line ~= '' and line:sub(1, 1) ~= '#' then
      local text, code, raw_weight = line:match('^([^\t]+)\t([^\t]+)\t([^\t]+)$')
      local weight = tonumber(raw_weight)
      if not text or not utf8.len(text) or text:find('[%z\1-\31\127]')
          or not code:match('^[a-z ]+$') or code:sub(1, 1) == ' '
          or code:sub(-1) == ' ' or code:find('  ', 1, true)
          or not weight or weight ~= weight or weight <= 0 or weight > 2147483647 then return false end
      local identity = text .. '\t' .. code
      if seen[identity] then return false end
      seen[identity], count = weight, count + 1
    end
  end
  if count == 0 then return false end
  return seen, count, config
end

local function validate_cn(contents, module)
  local original, original_count, config = read_cn(contents['words.dict.yaml'],
    module.files['words.dict.yaml'], module, 'words', true)
  if not original then return false end
  local patch = config:get_map('patch')
  if not patch or patch.size ~= 1 then return false end
  local item = patch:get('translator/packs/+')
  local list = item and item:get_list()
  local first = list and list:get_value_at(0)
  if list and list.size == 1 and first and first.value == 'rymcp_dlc_' .. module.id then
    module.packs = {first.value}
    return true
  end
  local include = patch:get_value('__include')
  if module.id ~= 'poetry' or not include
      or include.value ~= 'rymcp_dlc/poetry/words_00.dict:/activation' then return false end
  local combined, total, packs = {}, 0, {}
  for index = 0, 31 do
    local suffix = string.format('%02d', index)
    local name = 'rymcp_dlc_poetry_' .. suffix
    local relative = 'words_' .. suffix .. '.dict.yaml'
    if not contents[relative] then return false end
    local entries, count, piece_config = read_cn(contents[relative], module.files[relative],
      module, 'words_' .. suffix, false)
    if not entries then return false end
    local activation = piece_config:get_map('activation')
    if not activation or activation.size ~= 1 then return false end
    if index < 31 then
      local next_piece = activation:get_value('__include')
      local expected = string.format('rymcp_dlc/poetry/words_%02d.dict:/activation', index + 1)
      if not next_piece or next_piece.value ~= expected then return false end
    else
      local final_item = activation:get('translator/packs/+')
      local final_list = final_item and final_item:get_list()
      if not final_list or final_list.size ~= 32 then return false end
      for part = 0, 31 do
        local value = final_list:get_value_at(part)
        if not value or value.value ~= string.format('rymcp_dlc_poetry_%02d', part) then return false end
      end
    end
    for identity, weight in pairs(entries) do
      if combined[identity] or original[identity] ~= weight then return false end
      combined[identity] = weight
    end
    total, packs[#packs + 1] = total + count, name
  end
  if total ~= original_count then return false end
  module.packs = packs
  return true
end

function M.read(id)
  if not known[id] then return nil end
  local directory = rime_api.get_user_data_dir() .. '/rymcp_dlc/' .. id
  local manifest = read_file(directory .. '/manifest.tsv', 65536)
  local module = manifest and parse_manifest(manifest, id)
  if not module then return nil end
  module.directory, module.files = directory, {}
  local contents = {}
  for relative, entry in pairs(module.entries) do
    local path = directory .. '/' .. relative
    local data = read_file(path, MAX_FILE)
    if not data or #data ~= entry.size or adler32(data) ~= entry.checksum then return nil end
    module.files[relative], contents[relative] = path, data
  end
  if module.languages.cn
      and not validate_cn(contents, module) then return nil end
  if module.languages.en then
    local ok, format = pcall(require, 'en_dlc_format')
    if not ok then return nil end
    module.english = format.parse(contents['english.tsv'])
    if not module.english then return nil end
  end
  module.entries = nil
  return module
end

function M.modules()
  local result = {}
  for _, id in ipairs(ids) do
    local ok, module = pcall(M.read, id)
    if ok and module then result[#result + 1] = module end
  end
  return result
end

return M
