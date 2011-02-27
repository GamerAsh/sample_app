class MicropostsController < ApplicationController

  before_filter :authenticate
  before_filter :authorised_user, :only => :destroy
  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      redirect_to root_path, :flash => {:success => "Micropost Created!"}

    else
      @feed_items = []

    render 'pages/home'

    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_path, :flash => {:success => "Message Deleted!"}
  end

  private

  def authorised_user
    @micropost = Micropost.find(params[:id])
    redirect_to root_path unless current_user?(@micropost.user)
  end


end