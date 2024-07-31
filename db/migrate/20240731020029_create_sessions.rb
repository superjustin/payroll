class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions do |t|
      t.references :employee, null: false, foreign_key: true
      t.date :date
      t.string :session_type

      t.timestamps
    end
  end
end
