class CreateEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :employees do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name
      t.decimal :rate

      t.timestamps
    end
  end
end
