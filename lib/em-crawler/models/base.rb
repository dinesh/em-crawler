# https://github.com/mikewadhera/relational/blob/master/test.rb

require 'active_record'
require 'mysql2'
require 'active_record/connection_adapters/em_mysql2_adapter'
require 'logger'

ActiveRecord::Base.default_timezone = :utc
ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.logger.level = Logger::DEBUG
ActiveRecord::Base.pluralize_table_names = true
ActiveRecord::Base.time_zone_aware_attributes = true

module Models
  class Base < ActiveRecord::Base
    include EMCrawler
    self.abstract_class = true
    establish_connection EMCrawler.config.database
  end  
end


