require 'nokogiri'
require 'open-uri'
require 'pp'
require 'rspec'
require 'rubygems'

def skip_ad_page
  begin
    skip_ad_img = @doc.at_xpath("//img[contains(@src,'"'prestitial_skipad_v2_172x118.gif'"')]")
    skip_ad_img.click
   rescue
   end
end

describe "Test", :type => :selenium do
  before(:all) do
    @doc = Nokogiri::HTML(open("http://www.nyq.pcmag.com/article2/0,2817,2415021,00.asp/"))
  end

  it "can find the right title" do
    @doc.at_css('h1').text.should include("Unboxing the Microsoft Surface Windows 8 Pro")
  end

   it "can find gallery links and cycle through the slideshow" do
    gallery_links = @doc.xpath('//a[contains(text(), "VIEW ALL PHOTOS IN GALLERY")]')
    gallery_links.count.should eql(3)

    gallery_links.each do |link|
      pp link.content
    end

    gallery_links[1].click
    skip_ad_page
    #@driver.find_element(:class, "next-slide").click
    #@wait.until { @driver.find_element(:class, "bar") }
    #@driver.find_element(:class, "bar").text.split('/').first.to_i.should eql(2)

    #@driver.find_element(:class, "prev-slide").click
    #@wait.until { @driver.find_element(:class, "bar") }
    #@driver.find_element(:class, "bar").text.split('/').first.to_i.should eql(1)
  end
end