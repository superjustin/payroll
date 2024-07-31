class CreatePayrollPeriods < ActiveRecord::Migration[7.1]
  def change
    create_table :payroll_periods do |t|
      t.references :organization, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.string :period_type

      t.timestamps
    end
  end
end
