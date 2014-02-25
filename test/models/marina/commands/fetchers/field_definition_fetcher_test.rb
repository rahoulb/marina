require 'minitest/autorun'
require 'mocha/setup'
require_relative '../../../../../app/models/marina/commands/fetchers/field_definition_fetcher'

describe Marina::Commands::Fetchers::FieldDefinitionFetcher do
  subject { Marina::Commands::Fetchers::FieldDefinitionFetcher.new }

  it "does not require any special permissions" do
    subject.permission.must_equal nil
  end
end
