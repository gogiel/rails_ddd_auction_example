module Bidding
  module Commands
    class PlaceBid
      def self.call(...)
        new(...).call
      end

      def initialize(auction_id:, bidder_id:, amount:)
        @auction_id = auction_id
        @bidder_id = bidder_id
        @amount = amount
      end

      def call
        EntityMapper::Transaction.call do |context|
          auction_record = Auction.find(@auction_id)
          auction = context.read(AuctionMapping, auction_record)

          auction.place_bid(bidder_id: @bidder_id, amount: @amount)
        end
      end
    end
  end
end
