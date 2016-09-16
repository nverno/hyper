require 'HTTParty'
require 'Nokogiri'

module Hyper
  DOM = "http://hyperpolyglot.org"
  @@index = nil
  @@pages = nil

  def self.parse_index
    index = Nokogiri::HTML(HTTParty.get(DOM))
    tables = index.xpath("//table").collect { |x| x }

    dat = {}
    tables.each do |item|
      item.css('td a').each do |x|
        href = x['href']
        x.content.gsub(/[\t\n]/, ' ').downcase.split(', ').each do |lang|
          dat[lang] = href
        end
      end
    end
    @@index = dat
    @@pages = {}
    nil
  end

  def self.parse_page path
    page = Nokogiri::HTML(HTTParty.get(DOM + path))
    hrefs = page.at_xpath('//p').next.next

    # some pages have two sheets, one of which links to different page
    if /^\// =~ hrefs.css('a').first['href']
      hrefs = page.at_xpath('//p').next.next.next
    end

    # main sections
    h = {}
    hrefs.xpath('a').each do |x|
      tag = x['href'][-1..1]
      h[tag] = {}
      h[tag]["top"] = x['href']
    end

    # add nodes for subsections
    h.each do |k, v|
      section = page.at_css("#{v['top']}").at_xpath("ancestor::tr")
      while !h.has_key? section.xpath("th/a/@id").text
        unless section.xpath('td').empty?

        end
        section = section.next
      end
    end
    @@pages[path] = h
    nil
  end

  def self.get_index
    @@index.keys
  end

  def self.get_ids path
    @@pages[path].keys
  end

  def self.get_uri path, id
    DOM + @@pages[path][id]
  end

  def self.lookup (page=nil, id=nil)
    parse_index if @@index.nil?
    if page.nil?
      get_index
    else
      path = @@index[page]
      return nil if path.nil?
      parse_page path if @@pages[path].nil?
      if id.nil?
        get_ids path
      else
        get_uri path, id rescue nil
      end
    end
  end
end

Hyper.lookup "python", "functions"
