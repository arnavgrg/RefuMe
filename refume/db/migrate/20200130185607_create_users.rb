class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :age
      t.integer :zipcode
      t.string :phone
      t.string :country
      t.string :type
      t.string :goals

      t.timestamps
    end
  end
end
