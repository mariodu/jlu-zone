class Wiki::Builders::ListBuilder
  include Wiki::Builders::ShowColumns
  include Wiki::Builders::TemplateMethods
  include Wiki::Builders::ShowText
  
  class Column
    attr_accessor :method
    attr_accessor :build_body_column_method
    attr_accessor :build_header_column_method
  end

  attr_accessor :body_row_options
  attr_accessor :table_options
  attr_accessor :columns

  def initialize(template, text_group)
    @template    = template
    @text_group  = text_group
    self.columns = []
  end

  def build_list(models, &block)
    block.call(self)        
    self.table_options ||= {}
    self.table_options[:class] ||= ""
    self.table_options[:class] += " table table-condensed"
    contents_tag(:table, self.table_options) do |contents|
      contents << self.build_header
      contents << self.build_body(models)
    end
  end

  def build_header
    self.content_tag :thead do          
      self.contents_tag :tr do |contents|
        self.columns.each do |column|
          contents << self.build_header_column(column)            
        end
      end
    end
  end

  def build_header_column(column)
    if column.build_header_column_method
      column.build_header_column_method.call(column)
    else
      self.content_tag(:th) do 
        if column.method
          text_id = column.method
          self.show_current_itext(text_id)
        end
      end
    end
  end

  def build_body(models)
    models ||= []
    contents_tag :tbody do |contents|
      if models.count == 0
        contents << build_body_row_for_no_record
      else
        models.each do |model|
          contents << build_body_row(model)
        end
      end
    end
  end

  def build_body_row(model)
    options = self.build_body_row_options
    contents_tag(:tr, :class => "#{options}")do |contents|
      self.columns.each do |column|
        contents << self.build_body_column(column, model)
      end
    end
  end

  def build_body_row_options
    even = self.cycle('', 'even')
    if self.body_row_options
      self.body_row_options = nil
      return "#{even}"
    else
      self.body_row_options = 1
      return ""
    end
  end

  def build_body_row_for_no_record
    contents_tag :tr do |contents|
      self.columns.each_index do |index|
        contents << self.content_tag(:td) do
          show_itext('no_record') if index == 0
        end
      end
    end
  end

  def build_body_column(column, model)
    if column.build_body_column_method
      column.build_body_column_method.call(model)
    else
      self.tag(:td)
    end
  end

  def show_current_itext_base
    @text_group || self.controller_name.to_s.singularize
  end
end
