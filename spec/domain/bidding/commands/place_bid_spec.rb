describe Bidding::Commands::PlaceBid do
  let(:auction) { Auction.create!(starting_price: 5, ends_at: 1.hour.from_now) }
  let(:perform) do
    described_class.call(
      auction_id: auction.id,
      bidder_id: 1,
      amount: 10
    )
  end

  it "places a new bid" do
    perform

    auction.reload
    expect(auction.bids).to match_array(have_attributes(bid: 10, bidder_id: 1))
  end

  context "when already existing bid is lower than current bid" do
    let!(:existing_bid) { Bid.create!(auction: auction, bidder_id: 2, bid: 5) }

    it "places a new bid" do
      perform

      auction.reload
      expect(auction.bids).to match [
                                have_attributes(bid: 5, bidder_id: 2), have_attributes(bid: 10, bidder_id: 1)
      ]
    end
  end

  context "when already existing bid is higher than current bid" do
    let!(:existing_bid) { Bid.create!(auction: auction, bidder_id: 2, bid: 15) }

    it "raises an error" do
      expect { perform }.to raise_error(Bidding::Model::Auction::BiddingError, "Bid amount should be greater than highest bid amount")
    end
  end
end
