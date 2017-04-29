class CreateScores < ActiveRecord::Migration[5.0]
  def change
    create_table :scores do |t|
      t.belongs_to :player, index: true
      t.belongs_to :round,  index: true

      t.integer :points, null: false, default: 0

      t.timestamps
    end
  end
end
