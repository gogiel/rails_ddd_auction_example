module Bidding
  module Model
    class Auction
      BiddingError = Class.new(StandardError)

      def initialize(starting_price:, ends_at:)
        @starting_price = starting_price
        @ends_at = ends_at
        @bids_history = []
      end

      attr_accessor :starting_price, :ends_at, :bids_history

      def place_bid(bidder_id:, amount:)
        raise BiddingError, "Auction is over" if Time.now > ends_at

        bid = Bid.new(bidder_id: bidder_id, amount: amount)

        validate_bid!(bid)

        @bids_history << bid
      end

      def validate_bid!(bid)
        if bid.amount < starting_price
          raise BiddingError, "Bid amount should be greater than starting price"
        end

        minimal_amount = highest_bid_amount

        if minimal_amount && bid.amount <= minimal_amount
          raise BiddingError, "Bid amount should be greater than highest bid amount"
        end
      end

      def highest_bid_amount
        @bids_history.map(&:amount).max
      end
    end
  end
end
