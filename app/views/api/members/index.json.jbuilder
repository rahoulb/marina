json.members members do | member |
  json.partial! '/api/members/member', member: member, field_definitions: field_definitions
end