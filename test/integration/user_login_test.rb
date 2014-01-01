require "test_helper"

describe "UserLogin Integration Test" do
  describe "when given a valid username and password" do
    before do
      @member = a_saved Marina::Db::Member, username: 'test123', password: 'secret101', password_confirmation: 'secret101'
    end

    it "logs in" do
      get "/api/sessions/new?username=test123&password=secret101", format: 'json'

      response.status.must_equal 200

      session[:user_id].must_equal @member.id
    end

    it "returns information about the user" do
      get "/api/sessions/new?username=test123&password=secret101", format: 'json'

      data = JSON.parse(response.body)
      data["username"].must_equal 'test123'
      data["email"].must_equal @member.email
      data["firstName"].must_equal @member.first_name
      data["lastName"].must_equal @member.last_name
      data["subscriptionPlan"].must_equal ''
      data["subscriptionActive"].must_equal false
    end

    it "returns information about the current subscription" do
      @plan = a_saved Marina::Db::Subscription::PaidPlan, name: 'Paid'
      @subscription = a_saved Marina::Db::Subscription, plan: @plan, member: @member, expires_on: 2.days.from_now, active: true

      get "/api/sessions/new?username=test123&password=secret101", format: 'json'

      response.status.must_equal 200
      data = JSON.parse(response.body)
      data["subscriptionPlan"].must_equal 'Paid'
      data["subscriptionActive"].must_equal true
    end
  end

  describe "when the user is not found" do
    it "returns unauthorised" do
      get "/api/sessions/new?username=test123&password=notthepassword", format: 'json'

      response.status.must_equal 401
    end
  end

  describe "when the wrong password is supplied" do
    before do
      @member = a_saved Marina::Db::Member, username: 'test123', password: 'secret101', password_confirmation: 'secret101'
    end

    it "returns unauthorised" do
      get "/api/sessions/new?username=test123&password=notthepassword", format: 'json'

      response.status.must_equal 401
    end
  end
end
