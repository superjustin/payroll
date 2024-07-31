class PayrollPeriod < ApplicationRecord
  belongs_to :organization
  has_many :invoices
  has_many :sessions, through: :organization

  validate :no_overlapping_periods

  def run_payroll
    organization.employees.each do |employee|
      total_amount = employee.sessions.where(date: start_date..end_date).sum(:rate)
      Invoice.create(employee: employee, payroll_period: self, total_amount: total_amount)
    end
  end  

  def as_json(options = {})
    {
      id: id,
      title: start_date == end_date ? start_date.strftime('%m/%d/%Y') : "#{start_date.strftime('%m/%d/%Y')} - #{end_date.strftime('%m/%d/%Y')}",
      start: start_date,
      end: end_date + 1.day,
      period_type: period_type      
    }
  end  

  private

  def no_overlapping_periods
    overlapping_periods = organization.payroll_periods.where.not(id: id)
                                   .where("start_date <= ? AND end_date >= ?", end_date, start_date)
    if overlapping_periods.exists?
      errors.add(:base, "Payroll period overlaps with an existing period")
    end
  end  
end
