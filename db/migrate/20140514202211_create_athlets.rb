class CreateAthlets < ActiveRecord::Migration
  def change
    create_table :athlets do |t|
      t.integer :starter
      t.string :firstname
      t.string :surname
      t.date :birthday
      t.string :sex
      t.string :club
      t.string :event
      t.integer :relaytm
      t.integer :relaystarter

      t.timestamps
    end
  end
end
