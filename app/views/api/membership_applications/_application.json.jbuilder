json.cache! application do
  json.id application.id
  json.status application.status
  json.supporting_information application.supporting_information
  json.affiliate_membership_details application.affiliate_membership_details
  json.plan do
    json.id application.plan.id
    json.name application.plan.name
  end unless application.plan.nil?
  json.member do
    json.id application.member.id
    json.name application.member.name
  end unless application.member.nil?
  json.affiliate_organisation do
    json.id application.affiliate_organisation.id
    json.name application.affiliate_organisation.name
  end unless application.affiliate_organisation.nil?
end
