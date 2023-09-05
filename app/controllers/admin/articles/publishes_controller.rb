class Admin::Articles::PublishesController < ApplicationController
  layout 'admin'

  before_action :set_article

  def update
    update_status_and_published_at
    return if performed? # すでに render または redirect が行われていたら、処理を終了

    if @article.valid?
      Article.transaction do
        @article.body = @article.build_body(self)
        @article.save!
      end

      flash[:notice] = @article.state == 'publish_wait' ? '記事を公開待ちにしました' : '記事を公開しました'
      redirect_to edit_admin_article_path(@article.uuid)
    else
      flash.now[:alert] = 'エラーがあります。確認してください。'
      render 'admin/articles/edit' # ここでエラーが発生している可能性
    end
  end

  private

  def set_article
    @article = Article.find_by!(uuid: params[:article_uuid])
  end

  def update_status_and_published_at
    if @article.published_at.nil?
      flash.now[:alert] = '公開日時が設定されていません。'
      render('admin/articles/edit') && return # ここで return を追加
    end

    @article.state = if @article.published_at.to_datetime > Time.current
                       'publish_wait' # 文字列で設定
                     else
                       'published' # 文字列で設定
                     end
  end
end
