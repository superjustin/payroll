namespace :seed_data do
  desc "Generate an organization with seed data"
  task generate_organization: :environment do
    require 'faker'

    organization_name = Faker::Company.name
    organization = Organization.find_or_create_by(name: organization_name)

    # Create employees
    10.times do
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      rate = Faker::Number.between(from: 30, to: 100)

      Employee.find_or_create_by(name: "#{first_name} #{last_name}", rate: rate,organization: organization)
    end

    # Randomly choose a period type and generate payroll periods for a year
    period_types = ["weekly", "biweekly", "monthly"]
    period_type = period_types.sample

    # Use the existing method to generate payroll periods
    organization.generate_payroll_periods(period_type)

    puts "Organization '#{organization_name}' created successfully!"
  end
end
