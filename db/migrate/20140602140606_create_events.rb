class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.integer :team_size
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
