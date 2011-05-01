require 'helper'

class TestCrawler < Test::Unit::TestCase
  should "test the configuration" do
    connection = Models::Url.connection
    connection.active?.should eql(true)
  end
end
