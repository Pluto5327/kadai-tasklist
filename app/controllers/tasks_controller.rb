class TasksController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :new, :create]
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :select_user, only: [:show, :edit, :update, :destroy]
  
  def index
    if current_user
      @tasks = current_user.tasks.page(params[:page])
      @task = current_user.tasks.build
    end
  end

  def show
  end

  def new
    @task = current_user.tasks.build
  end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      flash[:success] = 'Task が正常に投稿されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task が投稿されませんでした'
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task.destroy

    flash[:success] = 'Tasks は正常に削除されました'
    redirect_to tasks_url
  end

  private

  # Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def set_task
    @task = Task.find(params[:id])
  end
  
  def select_user
    redirect_to root_path if @task.user != current_user
  end
end