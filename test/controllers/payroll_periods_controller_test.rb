# test/controllers/payroll_periods_controller_test.rb

require 'test_helper'

class PayrollPeriodsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = organizations(:one)
    @payroll_period = payroll_periods(:one)
  end

  test "should get index" do
    get organization_payroll_periods_url(@organization)
    assert_response :success
  end

  test "should create payroll period" do
    assert_difference('PayrollPeriod.count') do
      post organization_payroll_periods_url(@organization), params: { payroll_period: { start_date: Date.today, end_date: Date.today + 1.month } }
    end
    assert_response :created
  end

  test "should generate payroll periods" do
    post generate_payroll_periods_organization_payroll_periods_url(@organization), params: { period_type: 'monthly', start_date: Date.today.to_s }
    assert_response :success
  end

  test "should generate custom payroll periods" do
    post generate_custom_payroll_periods_organization_payroll_periods_url(@organization), params: { days: 14, start_date: Date.today.to_s }
    assert_response :success
  end
end
