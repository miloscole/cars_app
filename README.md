# CarsApp

"This is a simple demonstration application built with Ruby on Rails that covers basic CRUD operations for managing cars and linking them with customers."

## Ruby and Rails versions

This application requires Ruby version 3.2.0.
This application requires Rails version 7.0 or higher.

## System dependencies

Make sure you have PostgreSQL installed on your system. You can download and install PostgreSQL from
[here](https://www.postgresql.org/download/).

## Configuration

1. **Clone the repository:**

    git clone https://github.com/miloscole/cars_app.git

2. **Install dependencies:**

    `cd cars_app`
    `bundle install`

3. **Database configuration:**

    Update the `config/database.yml` file with your PostgreSQL username and password:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  username: your_username
  password: your_password
  host: localhost
  port: 5432
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

development:
  <<: *default
  database: cars_app_development

test:
  <<: *default
  database: cars_app_test
```
**Make sure you have created the databases (cars_app_development and cars_app_test) in your PostgreSQL instance.**

**Database creation:**

Run the following commands to create and migrate the databases:

`rails db:create`
`rails db:migrate`

# How to run the test suite

Run the test suite using the following command:

`rails test`
