class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.references :user

      t.string :description, null: false, default: ''

      t.timestamps
    end

    add_foreign_key :games, :users
  end
end
