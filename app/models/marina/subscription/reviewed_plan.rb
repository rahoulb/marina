module Marina
  module Subscription
    # The implementer should respond to auto_approval_code 
    module ReviewedPlan

      # params: supporting_information, auto_approval_code
      def new_application_from member, params = {}
        status = params[:auto_approval_code] == auto_approval_code ? 'approved' : 'awaiting_review'
        applications.create! member: member, supporting_information: params[:supporting_information], status: status
      end
    end
  end
end
