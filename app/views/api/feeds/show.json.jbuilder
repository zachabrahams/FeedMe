json.extract! @feed, :name

json.entries do
  json.partial! 'api/shared/entry_list', entries: @entries
end

if @feed.need_update?
  json.updating false
else
  json.updating true
end

json.updated_at @feed.updated_at
