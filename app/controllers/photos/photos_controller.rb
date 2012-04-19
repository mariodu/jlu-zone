# coding: utf-8
class Photos::PhotosController < ApplicationController
  include Wiki::Controllers::TabsHighLight::Base
  include Wiki::Controllers::TabsHighLight::Photos
  include Wiki::Controllers::Check
  before_filter :authenticate_user!,    :except => [:show, :index]
  load_and_authorize_resource

  respond_to :html, :js, :only => [:recent_photos]

  def index
    @photos = Photo.order("created_at desc").all
    @hot_photos = Photo.order("created_at desc").limit(4)
    drop_breadcrumb(itext("navigation.photos"), photos_path)
    do_not_use_sidebar
    render "photos/index"
  end

  def new
    @photo = current_user.photos.new
    render "photos/new"
  end

  def show
    @photo = Photo.find(params[:id])
    render "photos/show"
  end

  def edit
    @photo = current_user.photos.find(params[:id])
    render "photos/edit"
  end

  def create    
    @photo = current_user.photos.new(model_params)
    if @photo.save
      redirect_to_as_create_success photos_path
    else
      render_as_create_fail :new
    end
  end

  def update
    @photo = current_user.photos.find(params[:id])
    if @photo.update_attributes(model_params)
      redirect_to_as_update_success photos_path
    else
      render_as_update_fail :edit
    end
  end

  def recent_photos
    @photos = Photo.order("created_at desc").limit(10)
    respond_with do |format|
      format.json { render :json => all_to_json(@photos)}
    end
  end

  def destroy
    Photo.find(params[:id]).destroy
    redirect_to_as_destroy_success "/photos"
  end

  def all_to_json(photos)
    json_array = []
    photos.each do |photo|
      json_array << {
        :content => "<div class='slide_inner'><a target='_blank' class='photo_link' href=\"#{photo_path(photo)}\"><img class='photo' src=\"#{photo.img_url}\" alt='Bike'></a>#{time_ago(photo.created_at)}</div>",
      }
    end
    json_array
  end

  def time_ago(time, options = {})
    options[:class] ||= "timeago"
    content_tag(:abbr, "", options.merge(:title => time.iso8601)).html_safe if time
  end
end
