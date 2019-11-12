class CreateCountries < ActiveRecord::Migration[5.1]
  def change
    create_table :countries do |t|
      t.string :name
      t.string :iata_code
      t.integer :number_country
      t.timestamps
    end
  end
end
