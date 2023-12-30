module Bidding
  module Model
    class Auction
      def initialize(starting_price:, ends_at:)
        @starting_price = starting_price
        @ends_at = ends_at
        @bids = []
      end

      attr_accessor :starting_price, :ends_at
    end
  end
end
