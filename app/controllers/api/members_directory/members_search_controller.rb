class Api::MembersDirectory::MembersSearchController < ApplicationController
  respond_to :json

  def show
    members_searcher.fetch params do | found |
      render action: 'index', locals: { members: found, field_definitions: field_definitions }
    end
  end

  protected

  def members_searcher
    Marina::Commands::Fetchers::MembersSearcher.new({
      user: current_user,
      data_store: Marina::Db::Member.with_directory_listing, 
      field_definitions: field_definitions
    })
  end

  def field_definitions
    Marina::Db::FieldDefinition.all
  end
end
