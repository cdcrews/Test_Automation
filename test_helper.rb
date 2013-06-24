require 'pp'
require 'rubygems'

module Vars
  @@articlePageTitle
  @@slide1

  def self.articlePageTitle=(value)
    @@articlePageTitle = value
  end

  def self.articlePageTitle
    @@articlePageTitle
  end

  def self.slide1=(value)
    @@slide1 = value
  end

  def self.slide1
    @@slide1
  end
end

def BackToArticleLink(page)
    page.links.find { |l| l.text. =~ /Back to Article/i }
end

def FindAllLinksByHref(page, url)
     page.links.find_all { |l| l.href == url }
end

def FindAllLinksByText(page, reg)
  page.links.find_all { |l| l.text =~ reg }
end

def FindImageByAlt(page, alt)
    page.images.find { |i| i.alt == alt }
end

def FindLinkByAttribute(page, attribute, value)
    page.links.find { |l| l.attributes[attribute] == value }
end