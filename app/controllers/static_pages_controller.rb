class StaticPagesController < ApplicationController
  
  skip_before_action :require_login


  def root
    render :root
  end

end