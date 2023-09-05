class Admin::ArticlesController < ApplicationController
  layout 'admin'

  before_action :set_article, only: %i[edit update destroy]

  def index
    authorize(Article)
    @search_articles_form = SearchArticlesForm.new(search_params)
    @articles = @search_articles_form.search.order(id: :desc).page(params[:page]).per(25)
  end

  def new
    @article = Article.new
  end

  def create
    authorize(Article)
    @article = Article.new(article_params)
    @article.state = :draft # 初期状態はdraft
    if @article.save
      redirect_to edit_admin_article_path(@article.uuid)
    else
      render :new
    end
  end

  def edit
    authorize(@article)
  end

  def update
    authorize(@article)

    if @article.update(article_params)
      flash[:notice] = '更新しました'
      redirect_to edit_admin_article_path(@article.uuid)
    else
      Rails.logger.info "Update Failed: #{@article.errors.full_messages.join(', ')}"
      render :edit
    end
  end

  def destroy
    authorize(@article)
    @article.destroy
    redirect_to admin_articles_path
  end

  private

  def article_params
    params.require(:article).permit(
      :title, :description, :slug, :published_at, :eye_catch, :category_id, :author_id, tag_id: []
    )
  end

  def search_params
    params[:q]&.permit(:title, :category_id, :author_id, :tag_id, :body)
  end

  def set_article
    @article = Article.find_by!(uuid: params[:uuid])
  end
end
