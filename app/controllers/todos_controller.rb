class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :edit, :update, :destroy]

  def update
    if @todo.update(todo_params)
      @todo.update_user_level
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to request.referer || root_path, notice: 'Todo was successfully updated.' }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:error] = 'Todo update failed.'
          render turbo_stream: turbo_stream.replace('user_level', partial: 'users/level', locals: { user: current_user })
        end
        format.html do
          flash[:error] = 'Todo update failed.'
          redirect_to request.referer || root_path
        end
      end
    end
  end

  private

  def set_todo
    @todo = current_user.todos.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:checked)
  end
end
