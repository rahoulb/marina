json.cache! plan do
  json.id plan.id
  json.name plan.name
  json.active plan.active
  json.type plan.type
  json.number_of_members plan.members.count
  json.price plan.price
  json.length plan.length
  json.supporting_information_label plan.supporting_information_label
  json.supporting_information_description plan.supporting_information_description
end
