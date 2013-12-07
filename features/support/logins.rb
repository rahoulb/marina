module Logins
  extend ActiveSupport::Concern

  included do
    step 'I am logged in as a staff member' do
      @me = a_saved Marina::Db::Member, email: 'me@example.com', first_name: 'Me', last_name: 'Staff member'
    end

    step 'I am logged in as an administrator' do
      @me = a_saved Marina::Db::Member, email: 'me@example.com', first_name: 'Me', last_name: 'Staff member'
    end

    step 'I have mailout permissions' do
    end

  end
end
