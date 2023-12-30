class CreateAuctions < ActiveRecord::Migration[7.1]
  def change
    create_table :auctions do |t|
      t.decimal :starting_price, precision: 10, scale: 2, null: false
      t.datetime :ends_at, null: false

      t.timestamps
    end
  end
end
