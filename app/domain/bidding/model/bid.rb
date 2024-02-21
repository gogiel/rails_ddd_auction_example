module Bidding
  module Model
    class Bid
      def initialize(bidder_id:, amount:)
        @bidder_id = bidder_id
        @amount = amount

        @offer_time = Time.now
      end

      attr_accessor :bidder_id, :amount, :offer_time
    end
  end
end
