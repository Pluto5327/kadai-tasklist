class TasklistController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]
  
  def create
    @tasklist = current_user.tasklist.build(tasklist_params)
    if @taskist.save
      flash[:success] = 'メッセージを投稿しました。'
      redirect_to root_url
    else
      @tasklist = current_user.tasklist.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'メッセージの投稿に失敗しました。'
      render 'toppages/index'
    end
  end

  def destroy
    @tasklist.destroy
    flash[:success] = 'メッセージを削除しました。'
    redirect_back(fallback_location: root_path)
  end
  
  private

  def tasklist_params
    params.require(:tasklist).permit(:content)
  end
  
  def correct_user
    @tasklist = current_user.tasklist.find_by(id: params[:id])
    unless @tasklist
      redirect_to root_path
    end
  end
end
