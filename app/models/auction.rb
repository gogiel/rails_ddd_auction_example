class Auction < ApplicationRecord
  has_many :bids, dependent: :destroy
end
