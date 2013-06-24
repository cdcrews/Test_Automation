require 'mechanize'
require 'nokogiri'
require 'rspec'
require_relative 'test_helper'

describe 'Test', :type => :nokogiri do
  include Vars
  before(:all) do
    @agent = Mechanize.new
    @agent.user_agent_alias = 'Windows Mozilla'
    @url = 'http://www.nyq.pcmag.com/slideshow/story/307939/10-must-have-skyrim-mods'
    @article = @agent.get(@url)
  end

  it 'can find the right title' do
    @article.at('h1').text.should eql('10 Must-Have Skyrim Mods ')
    Vars.articlePageTitle = @article.title
  end

  it 'can find gallery links and cycle through the slideshow' do
    galleryLinks = FindAllLinksByHref(@article, "#{@url}/1")
    galleryLinks.count.should eql(2)

    slideshow = @agent.get(galleryLinks[1].href)
    nextSlideLink = FindLinkByAttribute(slideshow, 'class', 'next')
    slide2 = @agent.get(nextSlideLink.href)
    slide2.at('li.intro-slides').text.split('/').first.to_i.should eql(2)
    img2 = FindImageByAlt(slide2, 'ENB Series')  
    img2.src.should include('enb-series')
    BackToArticleLink(slide2).should_not eql(nil)

    prevSlideLink = FindLinkByAttribute(slide2, 'class', 'prev')
    Vars.slide1 = @agent.get(prevSlideLink.href)
    Vars.slide1.at('li.intro-slides').text.split('/').first.to_i.should eql(1)
    img1 = FindImageByAlt(Vars.slide1, 'SkyUI Mod')
    img1.src.should include('skyui-mod')
    BackToArticleLink(Vars.slide1).should_not eql(nil)
  end

  it 'can return back to article' do
    backToArticle = @agent.get(BackToArticleLink(Vars.slide1).href)
    backToArticle.title.should eql(Vars.articlePageTitle)
  end
end