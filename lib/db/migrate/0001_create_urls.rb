
class CreateUrls < ActiveRecord::Migration
    def self.up
      create_table :urls do |t|
        t.string :uri, :null       => false
        t.string :scheme, :default => 'http'
        t.string :host, :null      => false
        t.integer :port, :default  => 80
        t.string :query
        t.string :path
        t.float :page_rank, :default => 1
        t.string :fragement
        t.string :code, :unique => true 
        t.integer :outgoing_links, :default => 0
        t.integer :incoming_links, :default => 0
      end
      add_index :urls, :host
      add_index :urls, :code
      add_index :urls, :uri
      
      create_table :link_nodes do |t|
        t.integer :source_id, :null => false
        t.integer :destination_id, :null => false
      end
      add_index :link_nodes, [:source_id, :destination_id], :unique => true
      add_index :link_nodes, [:destination_id, :source_id], :unique => true
      
    end
    
    def self.down
      drop_table :urls
      drop_table :link_nodes
    end
end