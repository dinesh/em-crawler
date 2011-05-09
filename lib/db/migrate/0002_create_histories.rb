

class CreateHistories < ActiveRecord::Migration
  
  def self.up
    create_table :metadatas do |t| 
      t.integer :url_id, :null => false
      t.integer :fetch_interval
      t.datetime :fetched_at
      t.datetime :last_modified
      t.string :signature, :unique => true
      t.string :content_type
      t.string :content_encoding
      t.integer :content_length
      t.string :title
      t.string :author
      t.text :meta
      t.text :summary
    end
    
    add_index :metadatas, :url_id
    add_index :metadatas, :signature
  end
    
  def self.down
    drop_table :metadatas
  end
  
  
end
      