class CreateBids < ActiveRecord::Migration[5.0]
  def change
    create_table :bids do |t|
      t.belongs_to :player, index: true
      t.belongs_to :round, index: true

      t.integer :ordered, null: false, default:0
      t.integer :trick, null: false, default: 0

      t.timestamps
    end
  end
end
