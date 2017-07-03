class FavouritesController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    @micropost = Micropost.find(params[:micropost_id])
    current_user.favourite(@micropost)
    flash[:success] = 'Favourite!'
    redirect_to root_path
  end

  def destroy
    @micropost = Micropost.find(params[:micropost_id])
    current_user.unfavourite(@micropost)
    flash[:success] = 'Unfavourite!'
    redirect_to root_path
  end
end
