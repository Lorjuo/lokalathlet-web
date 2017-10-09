class AddAdditionalsToAthlets < ActiveRecord::Migration
  def change
    add_column :athlets, :additionals, :json
  end
end
