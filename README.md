
# Payroll Application

## Description

The Payroll Application is designed to simplify the payroll management process for administrators. This application allows payroll administrators to customize payroll period start and end dates using standard payroll periods of weekly, biweekly, and monthly, as well as custom payroll periods. 

With a user-friendly interface, administrators can easily view and manage payroll periods through a calendar view. The app supports draggable and selectable periods, making it easy to adjust payroll dates. The application leverages modern web technologies including Stimulus, Turbo, Hotwire, and FullCalendar.

## Features

- **Standard Payroll Periods**: Easily generate payroll periods for weekly, biweekly, and monthly intervals.
- **Custom Payroll Periods**: Create custom payroll periods with a specified number of days.
- **Calendar View**: Visualize and manage payroll periods on an interactive calendar.
- **Draggable Events**: Adjust payroll period dates by dragging events on the calendar.
- **Clear Future or All Payroll Periods**: Options to clear future payroll periods or all payroll periods entirely.

## Technical Details

- **Framework**: Rails 7.1
- **JavaScript Libraries**: Stimulus, Turbo, Hotwire
- **Calendar**: FullCalendar
- **Database**: Postgres

## Installation

1. Clone the repository

2. Install dependencies:
   ```sh
   bundle install
   yarn install
   ```

3. Set up the database:
   ```sh
   rails db:create
   rails db:migrate
   rake seed_data:generate_organization
   ```

4. Start the Rails server:
   ```sh
   rails server
   ```

5. Open your browser and navigate to `http://localhost:3000` to access the application.

## Usage

- Navigate to the Payroll Periods section.
- Use the buttons to generate weekly, biweekly, monthly, or custom payroll periods.
- View and manage payroll periods on the calendar.
- Drag and drop events to adjust payroll period dates.
- Clear future payroll periods or all payroll periods as needed.

## Testing

To run the tests for the application, use the following command:
```sh
rails test
```

This will execute the test suite and ensure that the application is functioning as expected.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request with your changes. Ensure that your code adheres to the project's coding standards and includes relevant tests.
