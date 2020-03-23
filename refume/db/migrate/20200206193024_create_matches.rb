class CreateMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :matches do |t|
      t.integer :mentor_id
      t.integer :mentee_id
      t.timestamp :created_at
      t.timestamp :updated_at

      t.timestamps
    end
  end
end
