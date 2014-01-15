class Api::MembersDirectory::MembersSearchController < ApplicationController
  respond_to :json

  def show
    members_searcher.fetch last_name: params[:last_name] do | found |
      render action: 'index', locals: { members: found }
    end
  end

  protected

  def members_searcher
    Marina::Commands::Fetchers::MembersSearcher.new({
      user: current_user,
      data_store: Marina::Db::Member
    })
  end
end
