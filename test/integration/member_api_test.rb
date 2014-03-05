require_relative "../test_helper"

describe "Member Api Integration Test" do

  describe 'when user is not logged in' do
    it 'should not able to manage members' do
      list_members
      response_should_not_be_success
    end
  end

  describe 'when user is logged in' do
    describe 'and have invalid permissions' do
      it 'should not able to list members' do
        member.update_attribute :permissions, []
        login_as member
        list_members
        response_should_not_be_success
      end
    end

    describe 'and has valid valid permissions' do

      before(:all) do
        login_as member
        populate_few_dummy_users
      end

      describe 'when listing/searching members' do

        it 'should able to list all existing members' do
          list_members
          response_should_be_success
          response_body_should_contains_listed_member
        end

        it 'should able to search existing members' do
          list_members('alpha')
          response_should_be_success
          response_body_should_contains_listed_member
        end

        it 'should able to search existing member for partial matches' do
          list_members('pha')
          response_should_be_success
          response_body_should_contains_listed_member
        end

        it 'should return blank if result not found' do
          list_members('jimmy')
          response_should_be_success
          response_body_should_be_empty
        end
      end

    end

    let(:member) { a_saved Marina::Db::Member, permissions: ['manage_members'] }

  end

end

def populate_few_dummy_users
  a_saved Marina::Db::Member, username: 'alpha', email: 'apha@gmail.com'
  a_saved Marina::Db::Member, username: 'beta', email: 'beta@gmail.com'
end

def list_members(query=nil)
  get "/api/members", q: query, format: 'json'
end

def response_body_should_contains_listed_member
  parsed_body_response.present?.must_equal true
end

def response_body_should_be_empty
  parsed_body_response.empty?.must_equal true
end

def parsed_body_response
  parsed_response = JSON.parse(response.body)
  parsed_response['members']
end

def response_should_be_success
  response.status.must_equal 200
end

def response_should_not_be_success
  response.status.must_equal 401
end

