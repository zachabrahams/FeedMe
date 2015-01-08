class EntriesController < ApplicationController

  def index
    current_user.feeds.each { |feed| feed.update_entries! }  # remove bang for production
    @entries = current_user.entries.includes(:feed).order(published_at: :desc)
    render :index
  end

  def show
    @entry = Entry.find(params[:id])
    if current_user.entries.include?(@entry)
      render :show
    else
      flash[:errors]  = ["You don't subscribe to that feed."]
      redirect_to feeds_url
    end
  end

end
