class Organization < ApplicationRecord
  has_many :employees
  has_many :payroll_periods
  has_many :sessions, through: :employees  

  def generate_payroll_periods(period_type, start_date = nil)
    start_date ||= default_start_date(period_type)

    interval = case period_type
               when "weekly"
                 1.week
               when "biweekly"
                 2.weeks
               when "monthly"
                 1.month
               end

    periods_count = case period_type
                    when "weekly"
                      52
                    when "biweekly"
                      26
                    when "monthly"
                      12
                    end

    periods_count.times do
      if period_type == "monthly"
        end_date = start_date + 1.month
      else
        end_date = start_date + interval - 1.day
      end
      payroll_periods.create(start_date: start_date, end_date: end_date, period_type: period_type)
      start_date = end_date + 1.day
    end
  end  

  def generate_custom_payroll_periods(days, start_date = nil)
    start_date ||= Date.today.next_occurring(:sunday)
    periods_count = 365 / days

    periods_count.times do
      end_date = start_date + days.days - 1.day
      payroll_periods.create(start_date: start_date, end_date: end_date, period_type: "custom")
      start_date = end_date + 1.day
    end
  end  

  private

  def default_start_date(period_type)
    case period_type
    when "weekly", "biweekly"
      Date.today.next_occurring(:sunday)
    when "monthly"
      (Date.today + 1.month).beginning_of_month
    else
      raise ArgumentError, "Invalid period type"
    end
  end

end
