module Bidding
  AuctionMapping = EntityMapper.map do |m|
    m.model Bidding::Model::Auction

    m.property(:starting_price)
    m.property(:ends_at)

    m.has_many(:bids_history, persistence_name: :bids) do |bid_model|
      bid_model.model Bidding::Model::Bid
      bid_model.property(:bidder_id)
      bid_model.property(:amount, :bid)
    end
  end
end
