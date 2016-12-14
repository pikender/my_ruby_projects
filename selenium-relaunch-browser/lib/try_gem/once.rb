require "rubygems"
require "bundler/setup"
require "capybara"
require "capybara/dsl"
require "selenium/webdriver"

class TryGem
  include Capybara::DSL
  attr_accessor :dp

  def initialize(dp)
    @dp = dp
  end

  def profile(app)
    profile = Selenium::WebDriver::Chrome::Profile.new
    profile["download.default_directory"] = dp
    Capybara::Selenium::Driver.new(app, :browser => :chrome, :profile => profile)
  end

  def say
    puts 'Hi'
  end

  def capybara_setup
    Capybara.run_server = false

    Capybara.default_driver = :selenium

    browser = Capybara.register_driver :selenium do |app|
      profile = profile(app)
    end

    Capybara.app_host = 'http://localhost:3000'
  end

  def check
    visit('/home')
    click_link('download-test_link')
    sleep(2)
  end

  def do_it
    capybara_setup
    check
  end

  def run
    system({'DOWNLOAD_PATH' => dp}, './bin/run_once.rb')
  end
end
