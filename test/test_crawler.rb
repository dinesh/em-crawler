require 'helper'

class TestCrawler < Test::Unit::TestCase
  should "test the configuration" do
    connection = Models::Url.connection
    assert_equal connection.active?, true
  end
  
  context 'Url shortner testing' do
    setup do
      uri = Addressable::URI.parse('http://news.ycombinator.com/news')
      @url = Models::Url.new(:uri => uri.to_s, :scheme => uri.scheme, :port => uri.port, :query => uri.query, :host => uri.host, :fragement => uri.fragment)
    end
    
    should "generate the short url for a give url." do 
      @url.save
      assert_equal @url.host, 'news.ycombinator.com'
      assert_equal @url.code, (Models::Url.count + 1).to_s
    end
  end
  
  

end
