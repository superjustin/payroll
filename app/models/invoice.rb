class Invoice < ApplicationRecord
  belongs_to :employee
  belongs_to :payroll_period
end
