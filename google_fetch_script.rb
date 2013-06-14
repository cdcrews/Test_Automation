require 'pp'
require 'rspec'
require 'rubygems'
require 'selenium-webdriver'

describe "Test", :type => :selenium do
  attr_reader :driver
  attr_reader :wait
  before(:all) do
    @driver = Selenium::WebDriver.for :firefox
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  after(:each) do
    @driver.quit
  end

  it "can find the right title" do
    @driver.navigate.to "https://www.google.com/webmasters/tools/googlebot-fetch?hl=en&siteUrl=http://www.geek.com/"
    @wait.until { @driver.title.downcase.start_with? "webmaster tools" }
    email_input = @driver.find_element(:id, 'Email')
    email_input.send_keys ""
    #pw_input = @driver.find_element(:id, 'Passwd')
    #pw_input.send_keys ""
    pw_input.submit
    @wait.until { @driver.find_element(:id, 'gbgs4dn')}
    #this needs to be in a loop of 500
    #fetch_url_input = @driver.find_element(:id, 'fetch_url_input')
    #fetch_url_input.send_keys "Hello WebDriver!" send url to fetch
    #fetch_url_input.submit
    status = driver.find_element(:xpath, "//*[@id='"'status-link'"']/a")
    #pp status
    status.text.should eql("Success")
  end
end