json.cache! mailout do
  json.id mailout.id
  json.sender do
    json.id mailout.sender.id
    json.name mailout.sender.name
  end
  json.subject mailout.subject
  json.from_address mailout.from_address
  json.contents mailout.contents
  json.send_to_all_members mailout.send_to_all_members
  json.test mailout.test
  json.recipient_plan_ids mailout.recipient_plan_ids
end
