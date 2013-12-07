class Marina::Db::Mailout::Delivery < ActiveRecord::Base
  belongs_to :mailout, class_name: 'Marina::Db::Mailout', foreign_key: 'mailout_id'
  belongs_to :member, class_name: 'Marina::Db::Member', foreign_key: 'member_id'
end
