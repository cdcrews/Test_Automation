require 'mechanize'
require 'nokogiri'
require 'pp'
require 'rspec'
require 'rubygems'

describe 'Test', :type => :nokogiri do
  before(:all) do
    @agent = Mechanize.new
    @agent.user_agent_alias = 'Windows Mozilla'
    @article = @agent.get('http://www.nyq.pcmag.com/article2/0,2817,2415021,00.asp/')
  end

  it 'can find the right title' do
    @article.at('h1').text.should eql('Unboxing the Microsoft Surface Windows 8 Pro')
    $articlePageTitle = @article.title
  end

  it 'can find gallery links and cycle through the slideshow' do
    galleryLinks = @article.links.find_all { |l| l.text =~ /VIEW ALL PHOTOS IN GALLERY/ }
    galleryLinks.count.should eql(3)
    slideshow = @agent.get(galleryLinks[1].href)
    nextSlideLink = slideshow.links.find { |l| l.attributes['class'] == 'next-slide' }
    slide2 = @agent.get(nextSlideLink.href)
    slide2.at('div.bar').text.split('/').first.to_i.should eql(2)
    img2 = slide2.images.find { |i| i.alt == 'Peripherals' }
    img2.src.should include('peripherals')

    prevSlideLink = slide2.links.find { |l| l.attributes['class'] == 'prev-slide' }
    $slide1 = @agent.get(prevSlideLink.href)
    $slide1.at('div.bar').text.split('/').first.to_i.should eql(1)
    img1 = $slide1.images.find { |i| i.alt == 'Press Kit' }
    img1.src.should include('press-kit')
  end

  it 'can return back to article' do 
    backToArticleLink = $slide1.links.find { |l| l.text == 'Back to article' }
    backToArticle = @agent.get(backToArticleLink.href)
    backToArticle.title.should eql($articlePageTitle)
  end
end