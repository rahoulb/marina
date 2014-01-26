module Marina
  module Subscription
    # The implementer should respond to auto_approval_code 
    module ReviewedPlan

      # params: supporting_information, auto_approval_code, affiliate_organisation, affiliate_membership_details
      def new_application_from member, params = {}
        applications.create! member: member, supporting_information: params[:supporting_information], status: status_from(params), affiliate_organisation: params[:affiliate_organisation], affiliate_membership_details: params[:affiliate_membership_details]
      end

      protected

      def status_from params
        params[:auto_approval_code] == auto_approval_code ? 'approved' : 'awaiting_review'
      end
    end
  end
end
