class CreateMarinaDbSubscriptionReviewedPlanApplications < ActiveRecord::Migration
  def change
    create_table :marina_db_subscription_reviewed_plan_applications do |t|
      t.belongs_to :plan
      t.belongs_to :member
      t.belongs_to :administrator
      t.belongs_to :affiliated_organisation
      t.string :affiliate_membership_details, length: 128
      t.text :supporting_information, :reason_for_rejection, :reason_for_affiliation_rejection
      t.string :status, length: 32, default: 'awaiting_review', null: false
      t.timestamps
    end
    add_index :marina_db_subscription_reviewed_plan_applications, :plan_id, name: 'reviewed_plan_applications_plan_id'
  end
end
