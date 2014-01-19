class Api::MembersDirectory::LatestMembersController < ApplicationController
  respond_to :json

  def show
    latest_members_finder.fetch count: params[:id].to_i do | found |
      render template: '/api/members_directory/members_search/index', locals: { members: found }
    end
  end

  protected

  def latest_members_finder
    Marina::Commands::Fetchers::LatestMembersFetcher.new({
      user: current_user,
      data_store: Marina::Db::Member
    })
  end
end
