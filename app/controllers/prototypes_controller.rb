class PrototypesController < ApplicationController
  before_action :authenticate_user!,only:[:new,:edit,:destroy]
  before_action :move_to_index, only:[:edit]

  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.create(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      render new_prototype_path
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    # show内の画像表示にも使っている→<%= image_tag @prototype.image %>
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype.id)
    else
      render :edit
    end
    # 更新成功→詳細画面偏移　更新失敗→編集画面偏移の処理
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end

  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy,:concept,:image).merge(user_id: current_user.id)
  end

  def move_to_index
    @prototypess = Prototype.find(params[:id])
    unless user_signed_in? && current_user.id == @prototypess.user_id
      redirect_to action: :index
    end
  end

end
