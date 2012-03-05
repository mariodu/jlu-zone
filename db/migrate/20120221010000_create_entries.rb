class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries, :force => true do |t|
      t.string      :name,         :limit   => 64,   :null => false
      t.references  :fonder,       :null    => false
      t.references  :category,     :null    => false
      t.text        :content
      #t.string      :number,       :null    => false
      t.integer     :appreciation, :default => 0
      t.integer     :objection,    :default => 0
      t.timestamps
    end
    add_index :entries, :fonder_id, :name => :index_find_entry_by_fonder_id
    #add_index :entries, :number,    :name => :index_find_entry_by_number
  end

  def self.down
    remove_index :entries, :name => :index_find_entry_by_fonder_id
    #remove_index :entries, :name => :index_find_entry_by_number
    drop_table   :entries
  end
end
