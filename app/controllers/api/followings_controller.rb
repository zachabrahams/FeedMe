class Api::FollowingsController < ApplicationController

  def create
    @curator = User.find(params[:user_id])
    puts @curator.to_s
    if current_user.curators << @curator
      render json: {notice: "You are now following #{@curator.username}."}
    else
      render json: {error: "We have encountered a problem with setting up the following."}
    end
  end

  def destroy
    @curator = User.find(params[:user_id])
    if current_user.curators.delete(@curator)
      render json: {notice: "You have successfully unfollowed #{@curator.username}."}
    else
      render json: {error: "We have encountered a problem with that unfollowing action."}
    end
  end

end
