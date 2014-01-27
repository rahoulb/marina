json.applications applications do | application |
  json.partial! '/api/membership_applications/application', application: application
end
