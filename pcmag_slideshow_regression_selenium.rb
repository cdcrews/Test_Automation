require 'pp'
require 'rspec'
require 'rubygems'
require 'selenium-webdriver'

def skip_ad_page
  begin
    skip_ad_img = @driver.find_element(:xpath, "//img[contains(@src,'"'prestitial_skipad_v2_172x118.gif'"')]")
    skip_ad_img.click
   rescue
   end
end

describe "Test", :type => :selenium do
  before(:all) do
    @driver = Selenium::WebDriver.for :firefox
    @wait = Selenium::WebDriver::Wait.new(:timeout => 5)
    @url = "http://www.nyq.pcmag.com/article2/0,2817,2415021,00.asp"
  end

  after(:all) do
    @driver.quit
  end

  it "can find the right title" do
    @driver.navigate.to @url
    @wait.until { @driver.find_element(:id, "cboxLoadedContent")}
    @driver.find_element(:id, "cboxClose").click #must close the email roadblock
    @driver.title.should include("Unboxing the Microsoft Surface Windows 8 Pro")
  end

  it "can find gallery links and cycle through the slideshow" do
    gallery_links = @driver.find_elements(:link, "VIEW ALL PHOTOS IN GALLERY")
    gallery_links.count.should eq(3)

    gallery_links.first.click
    @wait.until { @driver.title.include? "Slideshow" }
    skip_ad_page
    @driver.find_element(:class, "next-slide").click
    @wait.until { @driver.find_element(:class, "bar") }
    @driver.find_element(:class, "bar").text.split('/').first.to_i.should eql(2)
    
    @driver.find_element(:class, "prev-slide").click
    @wait.until { @driver.find_element(:class, "bar") }
    @driver.find_element(:class, "bar").text.split('/').first.to_i.should eql(1)
  end

  it "can return back to article" do
    back_to_article_link = @driver.find_element(:link, "Back to article")
    back_to_article_link.click
    skip_ad_page
    @driver.current_url.should eql(@url)
  end
end