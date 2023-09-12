class AddMainImagesToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :main_images, :json
  end
end
