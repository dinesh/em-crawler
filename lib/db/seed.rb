
Models::Url.delete_all
uri1 = Addressable::URI::parse('http://news.ycombinator.com')
uri2 = Addressable::URI::parse('http://news.google.com')
uri3 = Addressable::URI::parse('http://news.yahoo.com')

[uri1, uri2, uri3].each do |uri|
  Models::Url.init_from_address(uri).save
end
