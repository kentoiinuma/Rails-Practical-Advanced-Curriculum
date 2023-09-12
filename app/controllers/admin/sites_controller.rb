class Admin::SitesController < ApplicationController
  layout 'admin'

  before_action :set_site

  def edit
    authorize(@site)
  end

  def update
    authorize(@site)

    if @site.update(site_params)
      redirect_to edit_admin_site_path
    else
      render :edit
    end
  end

  def remove_image
    image = ActiveStorage::Attachment.find(params[:id])
    image.purge
    redirect_to edit_admin_site_path, notice: 'Image was successfully removed.'
  end

  private

  def site_params
    params.require(:site).permit(:name, :subtitle, :description, { main_images: [] }, :favicon, :og_image)
  end

  def set_site
    @site = Site.find(current_site.id)
  end
end
