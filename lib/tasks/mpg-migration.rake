namespace :mpg do
  task :migration => :environment do
    puts "Importing from existing MPG database..."
    puts "...field definitions"
    build_field_definitions
    puts "...subscription plans"
    build_subscription_plans
    puts "...connecting"
    connect_to_old_database
    puts "...copy data"
    copy_data
    puts "...done"
  end

  class LegacyMpgUser < ActiveRecord::Base
    has_many :member_skills, class_name: 'LegacyMpgMemberSkill', foreign_key: 'user_id'
    has_many :skills, through: :member_skills, class_name: 'LegacyMpgSkill'
  end

  class LegacyMpgMemberSkill < ActiveRecord::Base
    belongs_to :member, class_name: 'LegacyMpgUser', foreign_key: 'user_id'
    belongs_to :skill, class_name: 'LegacyMpgSkill', foreign_key: 'skill_id'
  end

  class LegacyMpgSkill < ActiveRecord::Base
    has_many :member_skills, class_name: 'LegacyMpgMemberSkill', foreign_key: 'skill_id'
  end

  def build_field_definitions
    Marina::Db::FieldDefinition.create! name: 'date_of_birth', label: 'DoB', kind: 'date' unless Marina::Db::FieldDefinition.names.include? :date_of_birth
    Marina::Db::FieldDefinition.create! name: 'myspace', label: 'Myspace', kind: 'short_text' unless Marina::Db::FieldDefinition.names.include? :myspace
    Marina::Db::FieldDefinition.create! name: 'skype', label: 'Skype', kind: 'short_text' unless Marina::Db::FieldDefinition.names.include? :skype
    Marina::Db::FieldDefinition.create! name: 'facebook', label: 'Facebook', kind: 'short_text' unless Marina::Db::FieldDefinition.names.include? :facebook
    Marina::Db::FieldDefinition.create! name: 'twitter', label: 'Twitter', kind: 'short_text' unless Marina::Db::FieldDefinition.names.include? :twitter
    Marina::Db::FieldDefinition.create! name: 'fax', label: 'Fax', kind: 'short_text' unless Marina::Db::FieldDefinition.names.include? :fax
    Marina::Db::FieldDefinition.create! name: 'mobile', label: 'Mobile', kind: 'short_text' unless Marina::Db::FieldDefinition.names.include? :mobile
    Marina::Db::FieldDefinition.create! name: 'company', label: 'Company', kind: 'short_text' unless Marina::Db::FieldDefinition.names.include? :company
    Marina::Db::FieldDefinition.create! name: 'management_name', label: 'Management name', kind: 'short_text' unless Marina::Db::FieldDefinition.names.include? :management_name
    Marina::Db::FieldDefinition.create! name: 'management_company', label: 'Management company', kind: 'short_text' unless Marina::Db::FieldDefinition.names.include? :management_company
    Marina::Db::FieldDefinition.create! name: 'management_telephone', label: 'Management telephone', kind: 'short_text' unless Marina::Db::FieldDefinition.names.include? :management_telephone
    Marina::Db::FieldDefinition.create! name: 'management_email', label: 'Management email', kind: 'short_text' unless Marina::Db::FieldDefinition.names.include? :management_email
    Marina::Db::FieldDefinition.create! name: 'accepts_interns', label: 'Accepts interns', kind: 'checkbox' unless Marina::Db::FieldDefinition.names.include? :accepts_interns
    Marina::Db::FieldDefinition.create! name: 'source', label: 'Source', kind: 'short_text' unless Marina::Db::FieldDefinition.names.include? :source
    Marina::Db::FieldDefinition.create! name: 'reason_for_interest', label: 'Reason for interest', kind: 'long_text' unless Marina::Db::FieldDefinition.names.include? :reason_for_interest
    Marina::Db::FieldDefinition.create! name: 'job_title', label: 'Job title', kind: 'short_text' unless Marina::Db::FieldDefinition.names.include? :job_title
    Marina::Db::FieldDefinition.create! name: 'roles', label: 'Roles', kind: 'multi_select', options: ["Producer", "Engineer", "Songwriter", "Programmer", "Mastering Engineer", "Musician", "Mixer", "Re-Mixer", "Arranger", "Education", "Gaming", "Multimedia", "Audio Tech", "Composer", "Songwriter"] unless Marina::Db::FieldDefinition.names.include? :roles
    Marina::Db::FieldDefinition.create! name: 'facilities', label: 'Facilities', kind: 'multi_select', options: ["Studio/several recording rooms", "Studio/single recording room", "Studio/vocal booth", "Studio/control room only", "Project studio", "Pro Tools HD", "Pro Tools M-Powered", "Pro Tools LE", "Logic Studio", "Digital Performer", "Cubase", "other DAW", "Nuendo"] unless Marina::Db::FieldDefinition.names.include? :facilities
    Marina::Db::FieldDefinition.create! name: 'genres', label: 'Genres', kind: 'multi_select', options: ["Pop", "Folk", "Rock", "Blues", "Film", "Multimedia", "Ambient", "Classical", "World", "Alternative", "Jazz", "Country", "R&B", "Soul", "Electronic", "Heavy Metal", "Reggae", "Death Metal", "Punk/Thrash", "Indie", "Urban", "Hip-Hop/Rap", "Dance", "House", "Chill", "Dub", "Trance", "Techno", "Drum&bass", "Garage"] unless Marina::Db::FieldDefinition.names.include? :genres
    Marina::Db::FieldDefinition.create! name: 'instruments', label: 'Instruments', kind: 'multi_select', options: ["Guitar", "Drums", "Bass", "Vocals", "Woodwind", "Strings", "Keyboards", "Percussion", "Brass", "Voice", "Organ", "Piano"] unless Marina::Db::FieldDefinition.names.include? :instruments
  end

  def build_subscription_plans
    Marina::Db::Subscription::PaidPlan.create! name: 'Associate (1 year)', price: 55.0, length: 12, feature_levels: ['Associate1'], plan_url: 'https://subs.pinpayments.com/api/v4/2399' if Marina::Db::Subscription::Plan.by_feature_level('Associate1').nil?
    Marina::Db::Subscription::PaidPlan.create! name: 'Associate (2 year)', price: 99.0, length: 24, feature_levels: ['Associate2'], plan_url: 'https://subs.pinpayments.com/api/v4/2402' if Marina::Db::Subscription::Plan.by_feature_level('Associate2').nil?
    Marina::Db::Subscription::PaidPlan.create! name: 'Associate (3 year)', price: 140.0, length: 36, feature_levels: ['Associate3'], plan_url: 'https://subs.pinpayments.com/api/v4/2403' if Marina::Db::Subscription::Plan.by_feature_level('Associate3').nil?

    Marina::Db::Subscription::PaidPlan.create! name: 'Associate (1 year) with Directory Listing', price: 80.0, length: 12, feature_levels: ['Associate1DL'], plan_url: 'https://subs.pinpayments.com/api/v4/2404', has_directory_listing: true if Marina::Db::Subscription::Plan.by_feature_level('Associate1DL').nil?
    Marina::Db::Subscription::PaidPlan.create! name: 'Associate (2 year) with Directory Listing', price: 149.0, length: 24, feature_levels: ['Associate2DL'], plan_url: 'https://subs.pinpayments.com/api/v4/2405', has_directory_listing: true if Marina::Db::Subscription::Plan.by_feature_level('Associate2DL').nil?
    Marina::Db::Subscription::PaidPlan.create! name: 'Associate (3 year) with Directory Listing', price: 215.0, length: 36, feature_levels: ['Associate3DL'], plan_url: 'https://subs.pinpayments.com/api/v4/2406', has_directory_listing: true if Marina::Db::Subscription::Plan.by_feature_level('Associate3DL').nil?

    Marina::Db::Subscription::PaidPlan.create! name: 'Associate (1 year) with Season Ticket', price: 80.0, length: 12, feature_levels: ['Associate1ST'], plan_url: 'https://subs.pinpayments.com/api/v4/2407', has_season_ticket: true if Marina::Db::Subscription::Plan.by_feature_level('Associate1ST').nil?
    Marina::Db::Subscription::PaidPlan.create! name: 'Associate (2 year) with Season Ticket', price: 149.0, length: 24, feature_levels: ['AssociateST'], plan_url: 'https://subs.pinpayments.com/api/v4/2408', has_season_ticket: true if Marina::Db::Subscription::Plan.by_feature_level('AssociateST').nil?
    Marina::Db::Subscription::PaidPlan.create! name: 'Associate (3 year) with Season Ticket', price: 215.0, length: 36, feature_levels: ['Associate3ST'], plan_url: 'https://subs.pinpayments.com/api/v4/2409', has_season_ticket: true if Marina::Db::Subscription::Plan.by_feature_level('Associate3ST').nil?

    Marina::Db::Subscription::PaidPlan.create! name: 'Associate (1 year) with Season Ticket and Directory Listing', price: 105.0, length: 12, feature_levels: ['Associate1DLST'], plan_url: 'https://subs.pinpayments.com/api/v4/2410', has_directory_listing: true, has_season_ticket: true if Marina::Db::Subscription::Plan.by_feature_level('Associate1DLST').nil?
    Marina::Db::Subscription::PaidPlan.create! name: 'Associate (2 year) with Season Ticket and Directory Listing', price: 174.0, length: 24, feature_levels: ['AssociateDLST'], plan_url: 'https://subs.pinpayments.com/api/v4/2411', has_directory_listing: true, has_season_ticket: true if Marina::Db::Subscription::Plan.by_feature_level('AssociateDLST').nil?
    Marina::Db::Subscription::PaidPlan.create! name: 'Associate (3 year) with Season Ticket and Directory Listing', price: 240.0, length: 36, feature_levels: ['Associate3DLST'], plan_url: 'https://subs.pinpayments.com/api/v4/2412', has_directory_listing: true, has_season_ticket: true if Marina::Db::Subscription::Plan.by_feature_level('Associate3DLST').nil?

    Marina::Db::Subscription::ReviewedPlan.create! name: 'Full Membership (1 year)', price: 120, length: 12, feature_levels: ['Full1'], plan_url: 'https://subs.pinpayments.com/api/v4/2398', has_directory_listing: true, has_season_ticket: true if Marina::Db::Subscription::Plan.by_feature_level('Full1').nil?
    Marina::Db::Subscription::ReviewedPlan.create! name: 'Full Membership (2 year)', price: 215, length: 24, feature_levels: ['Full2'], plan_url: 'https://subs.pinpayments.com/api/v4/2400', has_directory_listing: true, has_season_ticket: true if Marina::Db::Subscription::Plan.by_feature_level('Full2').nil?
    Marina::Db::Subscription::ReviewedPlan.create! name: 'Full Membership (3 year)', price: 305, length: 36, feature_levels: ['Full3'], plan_url: 'https://subs.pinpayments.com/api/v4/2401', has_directory_listing: true, has_season_ticket: true if Marina::Db::Subscription::Plan.by_feature_level('Full3').nil?
  end

  def connect_to_old_database
    puts "Database password: "
    password = STDIN.gets.strip

    [LegacyMpgUser, LegacyMpgMemberSkill, LegacyMpgSkill].each do | c |
      c.establish_connection({ 
        adapter: 'mysql2',
        database: 'mpg_legacy',
        host: 'db001.3hv.co.uk',
        username: 'mpg',
        password: password
      })
    end

    LegacyMpgUser.table_name = 'users'
    LegacyMpgMemberSkill.table_name = 'member_skills'
    LegacyMpgSkill.table_name = 'skills'
  end

  def copy_data
    LegacyMpgUser.find_each do | legacy_user |
      puts "... #{legacy_user.username}"
      new_user = Marina::Db::Member.where(username: legacy_user.username).first_or_create do | u | 
        u.last_name = legacy_user.last_name
        u.email = legacy_user.email
      end
      new_user.update_attributes!({
        payment_processor_id: legacy_user.id,
        visible_to: privacy_setting_for(legacy_user),
        visible_plans: visible_plans_for(legacy_user),
        encrypted_password: legacy_user.hashed_password,
        title: legacy_user.title,
        first_name: legacy_user.first_name,
        last_name: legacy_user.last_name,
        address: [legacy_user.address_1, legacy_user.address_2, legacy_user.address_3].compact.join("\n"),
        town: legacy_user.town,
        county: legacy_user.county,
        postcode: legacy_user.postcode,
        country: legacy_user.country,
        email: legacy_user.email,
        web_address: legacy_user.website,
        telephone: legacy_user.telephone,
        receives_mailshots: legacy_user.gets_newsletter,
        last_login_at: legacy_user.last_login_at,
        biography: legacy_user.profile,
        data: { 
          'date_of_birth' => legacy_user.date_of_birth,
          'myspace' => legacy_user.myspace,
          'skype' => legacy_user.skype,
          'facebook' => legacy_user.facebook,
          'twitter' => legacy_user.twitter,
          'fax' => legacy_user.fax,
          'mobile' => legacy_user.mobile,
          'company' => legacy_user.company,
          'management_name' => legacy_user.management_name,
          'management_company' => legacy_user.management_company,
          'management_telephone' => legacy_user.management_telephone,
          'management_email' => legacy_user.management_email,
          'accepts_interns' => legacy_user.accepts_interns, 
          'source' => legacy_user.source,
          'reason_for_interest' => legacy_user.reason_for_interest, 
          'job_title' => legacy_user.job_title,
          'roles' => roles_for(legacy_user),
          'genres' => genres_for(legacy_user),
          'facilities' => facilities_for(legacy_user),
          'instruments' => instruments_for(legacy_user)
        }
      })
      add_subscription(new_user, legacy_user) if legacy_user.is_active
    end
  end

  def privacy_setting_for legacy_user
    case legacy_user.make_me_private.to_s
    when 'public' then 'all'
    when 'members_only' then 'some'
    else 'none'
    end
  end

  def all_plan_ids
    @all_plan_ids ||= Marina::Db::Subscription::Plan.all.collect(&:id)
  end

  def visible_plans_for legacy_user
    case legacy_user.make_me_private.to_s
    when 'public' then all_plan_ids
    when 'members_only' then all_plan_ids
    else []
    end
  end

  def genres_for legacy_user
    skills_matching 'genre', legacy_user.skills
  end

  def roles_for legacy_user
    skills_matching 'role', legacy_user.skills
  end

  def instruments_for legacy_user
    skills_matching 'instrument', legacy_user.skills
  end

  def facilities_for legacy_user
    skills_matching 'facility', legacy_user.skills
  end

  def skills_matching skill_type, skills
    skills.select { | s | s.skill_type == skill_type }.collect(&:name)
  end

  def add_subscription new_user, legacy_user
    puts "... #{legacy_user.feature_level}"
    plan = Marina::Db::Subscription::Plan.by_feature_level legacy_user.feature_level
    subscription = new_user.subscriptions.where(plan_id: plan.id).first_or_initialize
    subscription.update_attributes! plan: plan, active: legacy_user.is_active, expires_on: legacy_user.subscribed_until, lifetime_subscription: legacy_user.lifetime_member, credit: legacy_user.credit
  end

end
