RSpec.describe Bidding::Model::Auction do
  it 'allows bidding when next bid is higher than a previous one' do
    auction = described_class.new(starting_price: 100, ends_at: 5.minutes.from_now)

    auction.place_bid(bidder_id: 'bidder1', amount: 100)
    auction.place_bid(bidder_id: 'bidder2', amount: 110)
    auction.place_bid(bidder_id: 'bidder1', amount: 111)
    auction.place_bid(bidder_id: 'bidder3', amount: 120)

    expect(auction.bids_history.count).to eq 4

    expect(auction.bids_history.last).to have_attributes(bidder_id: 'bidder3', amount: 120)
  end

  it 'does not allow bidding when auction is over' do
    auction = described_class.new(starting_price: 100, ends_at: 5.minutes.ago)

    expect { auction.place_bid(bidder_id: 'bidder1', amount: 100) }.
      to raise_error(Bidding::Model::Auction::BiddingError, "Auction is over")
  end

  it 'does not allow bidding when bid amount is lower than starting price' do
    auction = described_class.new(starting_price: 100, ends_at: 5.minutes.from_now)

    expect { auction.place_bid(bidder_id: 'bidder1', amount: 99) }.
      to raise_error(Bidding::Model::Auction::BiddingError, "Bid amount should be greater than starting price")
  end

  it 'does not allow bidding when bid amount is lower than highest bid amount' do
    auction = described_class.new(starting_price: 100, ends_at: 5.minutes.from_now)

    auction.place_bid(bidder_id: 'bidder1', amount: 100)
    auction.place_bid(bidder_id: 'bidder2', amount: 110)

    expect { auction.place_bid(bidder_id: 'bidder1', amount: 109) }.
      to raise_error(Bidding::Model::Auction::BiddingError, "Bid amount should be greater than highest bid amount")
  end
end
