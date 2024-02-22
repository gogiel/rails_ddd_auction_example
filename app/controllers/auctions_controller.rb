class AuctionsController < ApplicationController
  before_action :set_auction, only: %i[ show edit update destroy ]

  # GET /auctions
  def index
    @auctions = Auction.includes(:bids).all
  end

  # GET /auctions/1
  def show
  end

  # GET /auctions/new
  def new
    @auction = Auction.new
  end

  # GET /auctions/1/edit
  def edit
  end

  # POST /auctions
  def create
    auction_id = Bidding::Commands::CreateAuction.call(
      **auction_params.to_h.symbolize_keys
    )

    if auction_id
      redirect_to auction_path(auction_id), notice: "Auction was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def place_bid
    Bidding::Commands::PlaceBid.call(
      auction_id: params.fetch(:id), bidder_id: params.fetch(:bidder_id), amount: params.fetch(:amount).to_i
    )

    redirect_to auction_path(params[:id]), notice: "Bid was successfully placed."
  rescue Bidding::Model::Auction::BiddingError => e
    redirect_to auction_path(params[:id]), alert: e.message
  end

  # PATCH/PUT /auctions/1
  def update
    if @auction.update(auction_params)
      redirect_to @auction, notice: "Auction was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /auctions/1
  def destroy
    @auction.destroy!
    redirect_to auctions_url, notice: "Auction was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction
      @auction = Auction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def auction_params
      params.require(:auction).permit(:starting_price, :ends_at)
    end
end
