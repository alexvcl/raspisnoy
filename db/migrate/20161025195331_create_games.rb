class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.belongs_to :user
      t.belongs_to :current_round

      t.integer :status,      null: false, default: 0
      t.string  :description, null: false, default: ''

      t.timestamps
    end
  end
end
