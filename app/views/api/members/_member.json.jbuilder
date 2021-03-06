json.cache! [member, field_definitions] do 
  json.id member.id
  json.username member.username
  json.email member.email
  json.first_name member.first_name
  json.last_name member.last_name
  json.name member.name
  json.subscription_plan member.subscription_plan
  json.subscription_active member.subscription_active
  json.receives_mailshots member.receives_mailshots
  json.has_directory_listing member.has_directory_listing
  json.biography member.biography
  json.title member.title
  json.address member.address
  json.town member.town
  json.county member.county
  json.postcode member.postcode
  json.country member.country
  json.telephone member.telephone
  json.web_address member.web_address
  json.source member.source
  json.created_at member.created_at.to_date
  field_definitions.each do | field_definition |
    json.set! field_definition.name.to_s, member.value_for(field_definition)
  end
end
