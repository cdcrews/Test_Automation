require 'pp'
require 'rspec'
require 'rubygems'
require 'selenium-webdriver'

def isPresent?(how, what)
  begin
    @driver.find_element(how, what)
    return true
   rescue
     return false
   end
end

describe "Test", :type => :selenium do
  before(:all) do
    @driver = Selenium::WebDriver.for :firefox
    @wait = Selenium::WebDriver::Wait.new(:timeout => 5)
    @url = "http://qa.geek.com/news/welcome-to-the-new-geek-com-1544556/"
  end

  after(:all) do
    @driver.quit
  end

  it "can find the right title" do
    @driver.navigate.to @url
    articleTitle = @driver.find_element(:tag_name, "h2")
    articleTitle.text.should include("Welcome to the new Geek.com")
  end

  it "can find gallery links and cycle through the slideshow" do
    gallery_links = @driver.find_elements(:link, "VIEW PHOTO GALLERY")
    gallery_links.count.should eq(2)

    gallery_links.first.click
    @wait.until { @driver.find_element(:class, "fancybox-overlay") }

    @driver.find_element(:class, "tn3a-next").click
    sleep 1

    slide2Title = @driver.find_element(:class, "tn3a-image-title").text
    slide2Img = @driver.find_element(:xpath, "//*[@id='gallery']/div[1]/div/div[2]/div[1]/div[1]/div[1]/div/img")
    slide2Img.attribute("alt").should eql(slide2Title)

    closeGalleryLink = @driver.find_element(:class, "fancybox-close")
    
    @driver.execute_script("arguments[0].click()" , closeGalleryLink) # must use execute_script here due to javascript element
    sleep 1

    isPresent?(:class, "fancybox-overlay").should eql(false)

    gallery_links.first.click

    @driver.find_element(:class, "tn3a-prev").click
    sleep 1

    slide1Title = @driver.find_element(:class, "tn3a-image-title").text
    slide1Title.should_not eql(slide2Title)
    slide1Img = @driver.find_element(:xpath, "//*[@id='gallery']/div[1]/div/div[2]/div[1]/div[1]/div[1]/div/img")
    slide1Img.attribute("alt").should eql(slide1Title)
  end

  it "can return to article by clicking off gallery" do
    @driver.execute_script("arguments[0].click()" , @driver.find_element(:class, "fancybox-overlay")) # must use execute_script here due to javascript element
    sleep 1

    isPresent?(:class, "fancybox-overlay").should eql(false)
  end
end