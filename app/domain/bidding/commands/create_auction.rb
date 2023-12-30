module Bidding
  module Commands
    class CreateAuction
      def self.call(...)
        new(...).call
      end

      def initialize(starting_price: nil, ends_at: nil)
        @starting_price = starting_price
        @ends_at = ends_at
      end

      def call
        auction_record = Bidding::Model::Auction.new(
          starting_price: @starting_price,
          ends_at: @ends_at
        )

        EntityMapper::Transaction.call do |context|
          auction_record = context.create(AuctionMapping, auction_record, Auction)
          auction_record.id
        end
      end
    end
  end
end
