class PayrollPeriodsController < ApplicationController
  before_action :set_organization

  def index
    @payroll_periods = @organization.payroll_periods

    respond_to do |format|
      format.html
      format.json { render json: @payroll_periods.as_json }
    end
  end

  def update
    @payroll_period = @organization.payroll_periods.find(params[:id])
    if @payroll_period.update(payroll_period_params)
      @payroll_periods = @organization.payroll_periods
      broadcast_update
      respond_to do |format|
        format.json { render json: @payroll_period }
        format.turbo_stream
      end
    else
      render json: @payroll_period.errors, status: :unprocessable_entity
    end
  end

  def generate_payroll_periods
    period_type = params[:period_type]
    start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : nil
    begin
      @organization.generate_payroll_periods(period_type, start_date)
      @payroll_periods = @organization.payroll_periods
      broadcast_update
      render json: { message: "Payroll periods generated successfully" }, status: :ok
    rescue ArgumentError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end  

  def generate_custom_payroll_periods
    days = params[:days].to_i
    start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : nil
    begin
      @organization.generate_custom_payroll_periods(days, start_date)
      @payroll_periods = @organization.payroll_periods
      broadcast_update
      render json: { message: "Custom payroll periods generated successfully" }, status: :ok
    rescue ArgumentError => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.record.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def destroy
    @payroll_period = @organization.payroll_periods.find(params[:id])
    @payroll_period.destroy
    @payroll_periods = @organization.payroll_periods
    broadcast_update
    respond_to do |format|
      format.json { render json: { message: "Payroll period deleted successfully" }, status: :ok }
      format.turbo_stream
    end
  end

  def clear_future_payroll_periods
    if params[:all]
      @organization.payroll_periods.destroy_all
    else
      @organization.payroll_periods.where("start_date > ?", Date.today).destroy_all
    end    
    @payroll_periods = @organization.payroll_periods
    broadcast_update

    respond_to do |format|
      format.json { render json: { message: "Future payroll periods cleared successfully" }, status: :ok }
      format.turbo_stream
    end    
  end

  def create
    @payroll_period = @organization.payroll_periods.new(payroll_period_params)
    if @payroll_period.save
      @payroll_periods = @organization.payroll_periods
      broadcast_update
      render json: @payroll_period, status: :created
    else
      render json: { errors: @payroll_period.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_organization
    @organization = Organization.find(params[:organization_id])
  end

  def payroll_period_params
    params.require(:payroll_period).permit(:start_date, :end_date)
  end

  def broadcast_update
    Turbo::StreamsChannel.broadcast_replace_to @organization, target: "payroll-periods-body", partial: "payroll_periods/payroll_periods", locals: { payroll_periods: @payroll_periods }
  end  
end
