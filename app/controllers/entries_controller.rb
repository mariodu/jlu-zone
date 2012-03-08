class EntriesController < ApplicationController
  load_and_authorize_resource
  before_filter :authenticate_user!,    :except => [:show, :index]
  before_filter :find_current_category, :only   => [:index]

  attr_accessor :current_category
  
  helper_method :current_category

  def index
    @entries = current_category.entries.all
    drop_breadcrumb(current_category.name)
  end

  def show
    @entry = Entry.find(params[:id])
    drop_breadcrumb(@entry.category.name,category_entries_path(@entry.category))
    drop_breadcrumb(@entry.name)
  end

  def edit
    @entry = Entry.find(params[:id])
    drop_breadcrumb(@entry.category.name,category_entries_path(@entry.category))
    drop_breadcrumb(itext('entry.edit', :entry => @entry.name))
  end

  def new
    @entry = Entry.new
    drop_breadcrumb(itext('entry.new'))
  end

  def create
    @entry = Entry.create_entry(model_params, current_user)
    if @entry.save
      redirect_to_as_create_success [current_category, @entry]
    else
      render_as_create_fail :new
    end
  end
  
  def update
    @entry = Entry.find(params[:id])
    if @entry.update_entry(model_params, current_user)
      redirect_to_as_update_success [current_category, @entry]
    else
      render_as_update_fail :edit
    end
  end

  def destroy
    entry = Entry.find(params[:id])
    category = entry.category
    entry.destroy
    redirect_to_as_destroy_success category_entries_path(category)
  end

  protected

  def find_current_category
    return nil unless params[:category_number]
    self.current_category = Category.find_by_number(params[:category_number])
    self.catalog_type = :entry_category
    unless self.current_category
      raise "Can not find a Category with the number #{params[:category_number]}"
    end
  end
end