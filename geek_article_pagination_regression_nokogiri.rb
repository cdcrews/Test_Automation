require 'mechanize'
require 'nokogiri'
require 'rspec'
require_relative 'test_helper'

def ValidatePage(page, pagenationLinks, pageNum, pageCnt)
  nextLink = FindLinkByAttribute(page, 'class', 'next page-numbers')
  prevLink = FindLinkByAttribute(page, 'class', 'prev page-numbers')

  page.code.to_i.should eql(200)
  page.at('span.page-numbers.current').text.to_i.should eql(pageNum)

  if pageNum == 1
    page.uri.to_s.should eql(@url)
    nextLink.should_not be_nil
    prevLink.should be_nil
    pagenationLinks.count.should eql(pageCnt)
  elsif pageNum == pageCnt
    page.uri.to_s.should eql("#{@url}#{pageNum}/")
    nextLink.should be_nil
    prevLink.should_not be_nil
    pagenationLinks.count.should eql(pageCnt)
  else
    page.uri.to_s.should eql("#{@url}#{pageNum}/")
    nextLink.should_not be_nil
    prevLink.should_not be_nil
    pagenationLinks.count.should eql(pageCnt+1)
  end
end

describe 'Test', :type => :nokogiri do
  include Vars
  before(:all) do
    @agent = Mechanize.new
    @agent.user_agent_alias = 'Windows Mozilla'
    @url = 'http://qa.geek.com/games/five-great-games-like-minecraft-1533818/'
    @article = @agent.get(@url)
  end

  it 'can find the right title' do
    @article.at('h2').text.should eql('Five great games like Minecraft')
    Vars.articlePageTitle = @article.title
  end

  it 'can find pagination links' do
    @article.at('div.pagenationsearch').should_not be_nil
  end
    
  it 'can cycle through all of the pages' do
    pageLinks = FindAllLinksByAttribute(@article, 'class', /page-numbers/)
    ValidatePage(@article, pageLinks, 1, 3)

    page = @agent.click(pageLinks[0]) #click page 2 link
    pageLinks = FindAllLinksByAttribute(page, 'class', /page-numbers/)
    ValidatePage(page, pageLinks, 2, 3)

    page = @agent.click(pageLinks[3]) #click next link for page 3
    pageLinks = FindAllLinksByAttribute(page, 'class', /page-numbers/)
    ValidatePage(page, pageLinks, 3, 3)
  end
end