class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :payroll_period, null: false, foreign_key: true
      t.decimal :total_amount

      t.timestamps
    end
  end
end
