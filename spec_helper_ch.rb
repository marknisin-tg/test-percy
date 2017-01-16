require 'capybara'
require 'selenium-webdriver'
require 'rspec/expectations'
require 'capybara/rspec'
require 'percy/capybara'


include Capybara::DSL
# include Prickle::Capybara

Capybara.current_driver = :selenium_chrome
 Capybara.register_driver :selenium_chrome do |app|
   Capybara::Selenium::Driver.new(app, :browser => :chrome)
end
Capybara.ignore_hidden_elements = false
Capybara.javascript_driver = :selenium_chrome


browser = Capybara.current_session.driver.browser
# browser.manage.window.resize_to(1600, 800)
browser.manage.window.maximize
Capybara.default_max_wait_time = 4

# Capybara.app_host = 'http://localhost:9000'
# browser.manage.delete_all_cookies


RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.before(:suite) { Percy::Capybara.initialize_build }
  config.after(:suite) { Percy::Capybara.finalize_build }
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.filter_run :focus
  config.order = 'random'

  # Capybara.javascript_driver = :webkit
end
