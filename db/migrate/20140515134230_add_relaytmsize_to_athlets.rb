class AddRelaytmsizeToAthlets < ActiveRecord::Migration
  def change
    add_column :athlets, :relaytmsize, :integer
  end
end
