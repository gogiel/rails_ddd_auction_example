module Bidding
  AuctionMapping = EntityMapper.map do |m|
    m.model Bidding::Model::Auction

    m.property(:starting_price)
    m.property(:ends_at)
  end
end
