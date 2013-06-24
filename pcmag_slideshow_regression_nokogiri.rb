require 'mechanize'
require 'nokogiri'
require 'rspec'
require_relative 'test_helper'

describe 'Test', :type => :nokogiri do
  include Vars
  before(:all) do
    @agent = Mechanize.new
    @agent.user_agent_alias = 'Windows Mozilla'
    @article = @agent.get('http://www.nyq.pcmag.com/article2/0,2817,2415021,00.asp/')
  end

  it 'can find the right title' do
    @article.at('h1').text.should eql('Unboxing the Microsoft Surface Windows 8 Pro')
    Vars.articlePageTitle = @article.title
  end

  it 'can find gallery links and cycle through the slideshow' do
    galleryLinks = FindAllLinksByText(@article, /VIEW ALL PHOTOS IN GALLERY/)
    galleryLinks.count.should eql(3)
    slideshow = @agent.get(galleryLinks[1].href)
    nextSlideLink = FindLinkByAttribute(slideshow, 'class', 'next-slide')
    slide2 = @agent.get(nextSlideLink.href)
    slide2.at('div.bar').text.split('/').first.to_i.should eql(2)
    img2 = FindImageByAlt(slide2, 'Peripherals')
    img2.src.should include('peripherals')
    BackToArticleLink(slide2)

    prevSlideLink = FindLinkByAttribute(slide2, 'class', 'prev-slide')
    Vars.slide1 = @agent.get(prevSlideLink.href)
    Vars.slide1.at('div.bar').text.split('/').first.to_i.should eql(1)
    img1 = FindImageByAlt(Vars.slide1, 'Press Kit')
    img1.src.should include('press-kit')
    BackToArticleLink(Vars.slide1)
  end

  it 'can return back to article' do 
    backToArticle = @agent.get(BackToArticleLink(Vars.slide1).href)
    backToArticle.title.should eql(Vars.articlePageTitle)
  end
end