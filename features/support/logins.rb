module Logins
  extend ActiveSupport::Concern

  included do
    step 'I am logged in as a staff member' do
    end

    step 'I have mailout permissions' do
    end

  end
end
