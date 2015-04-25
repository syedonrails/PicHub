class Office < ActiveRecord::Base

  def self.lets_scrape
    require "amazon"

    require "amazon/aws"
    require "amazon/aws/search"
    il = Amazon::AWS::ItemLookup.new('ASIN', { 'ItemId'=>asin })

    rg = Amazon::AWS::ResponseGroup.new('Medium')
    req = Amazon::AWS::Search::Request.new
    resp = req.search(il, rg)
    puts "*******************************************************"
    puts resp.item_lookup_response.items[0].item.item_attributes.title.to_s
    puts "*******************************************************"
  end
end
