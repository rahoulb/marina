json.field_definitions field_definitions do | field_definition |
  json.partial! '/api/field_definitions/field_definition', field_definition: field_definition
end
