class AddMainImagesToSites < ActiveRecord::Migration[5.2]
  def change
    add_column :sites, :main_images, :json
  end
end

