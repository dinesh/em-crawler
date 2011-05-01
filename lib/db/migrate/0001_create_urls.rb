
class CreateUrls < ActiveRecord::Migration
    def self.up
      create_table :urls do |t|
        t.string :uri, :null       => false
        t.string :scheme, :default => 'http'
        t.string :host, :null      => false
        t.integer :port, :default  => 80
        t.string :query
        t.string :fragement
      end
      
    end
    
    def self.down
      drop_table :urls
    end
end