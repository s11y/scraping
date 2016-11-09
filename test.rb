# require 'sinatra'
require 'open-uri'
require 'nokogiri'
require 'robotex'
require 'csv'
require 'timeout'

# robotex_green = Robotex.new
# p robotex_green.allowed?("https://www.green-japan.com/search_key/01?key=c2rcue2d1cjknwgg9bbc&keyword=")
#
# url_green = 'https://www.green-japan.com/search_key/01?key=c2rcue2d1cjknwgg9bbc&keyword='
#
# user_agent_green = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'
# charset_green = nil
#
#
#
# arr_global_green = Array.new()
#
# for num in 1...188 do
#   puts num
#   url = url_green + '&page=' + num.to_s
#
#   html_green = open(url, "User-Agent" => user_agent_green) do |f|
#     charset_green = f.charset
#     f.read
#   end
#
#   doc_green = Nokogiri::HTML.parse(html_green, nil, charset_green)
#
#   doc_green.css('.srch-rslt > div').each { |div_tag|
#     arr = Array.new()
#     from_chr = "\u{301C 2212 00A2 00A3 00AC 2013 2014 2016 203E 00A0 00F8 203A}"
#     to_chr   = "\u{FF5E FF0D FFE0 FFE1 FFE2 FF0D 2015 2225 FFE3 0020 03A6 3009}"
#
#     url = 'https://www.green-japan.com' + div_tag.css('a').attr('href').value
#     url.tr!(from_chr, to_chr)
#     url = url.encode("Shift_JIS","UTF-8",:invalid => :replace,:undef=>:replace).encode("UTF-8","Shift_JIS")
#     title = div_tag.css('a > .card-info__heading-area > h3').text
#     title.tr!(from_chr, to_chr)
#     title = title.encode("Shift_JIS","UTF-8",:invalid => :replace,:undef=>:replace).encode("UTF-8","Shift_JIS")
#     company_name = div_tag.css('a > .card-info__detail-area > .card-info__detail-area__box > .card-info__detail-area__box__heading > h3').text
#     company_name.tr!(from_chr, to_chr)
#     company_name = company_name.encode("Shift_JIS","UTF-8",:invalid => :replace,:undef=>:replace).encode("UTF-8","Shift_JIS")
#
#     arr = [url, title, company_name]
#
#     arr_global_green.push(arr)
#   }
#
# end
#
# csv = CSV.open('export.csv', 'w', encoding: "Shift_JIS:UTF-8") do |io|
#   io << ['リンク', 'タイトル', '社名']
#
#   arr_global_green.each { |element|
#     io << element
#   }
# end


robotex_wantedly = Robotex.new
p robotex_wantedly.allowed?("https://www.wantedly.com/projects?type=mixed")

url_wantedly = "https://www.wantedly.com/projects?type=mixed"

user_agent_wantedly = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'
charset_wantedly = nil


arr_global_wantedly = Array.new()

for num in 0...16 do
  for number in 1...100 do
  page_number = (num * 100) + number
  puts page_number
  url = url_wantedly + '?page=' + page_number.to_s + '&project%5Bkeyword%5D='

  begin

  html_wantedly = open(url_wantedly, "User-Agent" => user_agent_wantedly) do |f|
    charset_wantedly = f.charset
    f.read
  end

  rescue Timeout::Error => e
     puts e.to_s
  end

  sleep(1)
  doc_wantedly = Nokogiri::HTML.parse(html_wantedly, nil, charset_wantedly)

  doc_wantedly.css('div.projects-index-list > article').each { |div_tag|

    arr = Array.new()

    from_chr = "\u{301C 2212 00A2 00A3 00AC 2013 2014 2016 203E 00A0 00F8 203A}" # 3231 FF5E
    to_chr   = "\u{FF5E FF0D FFE0 FFE1 FFE2 FF0D 2015 2225 FFE3 0020 03A6 3009}" # 878A 301C

    company_url = 'https://www.wantedly.com/' + div_tag.css('.company-name.company-without-prefecture > h3 > a').attr('href').value
    company_url.tr!(from_chr, to_chr)

    title = div_tag.css('.project-index-single-inner > .project-detail > h1 > a').text
    title.tr!(from_chr, to_chr)
    title.encode("Shift_JIS","UTF-8",:invalid => :replace,:undef=>:replace, :replace => "*").encode("UTF-8","Shift_JIS")

    link = 'https://www.wantedly.com/' + div_tag.css('.project-index-single-inner > .project-detail > h1 > a').attr('href').value
    link.tr!(from_chr, to_chr)
    link.encode("Shift_JIS","UTF-8",:invalid => :replace,:undef=>:replace, :replace=>"*").encode("UTF-8","Shift_JIS")

    company_name = div_tag.css('.company-name.company-without-prefecture > h3 > a').text
    company_name.tr!(from_chr, to_chr)
    company_name.encode("Shift_JIS","UTF-8",:invalid => :replace,:undef=>:replace, :replace=> '*').encode("UTF-8", "Shift_JIS")

    html_wantedly_company = open(company_url, "User-Agent" => user_agent_wantedly) do |f|
      charset_wantedly = f.charset
      f.read
    end


    doc_wantedly_company = Nokogiri::HTML.parse(html_wantedly_company, nil, charset_wantedly)
    company_domain_url = doc_wantedly_company.css('p.company-url > a').attr('href').value

    arr = [title, link, company_name, company_domain_url]
    arr_global_wantedly.push(arr)
    sleep(1)
  }
    end
end

for  number in 1600...1657 do
  url = url_wantedly + '?page=' + number.to_s + '&project%5Bkeyword%5D='

  begin

    html_wantedly = open(url_wantedly, "User-Agent" => user_agent_wantedly) do |f|
      charset_wantedly = f.charset
      f.read
    end

  rescue Timeout::Error => e
    puts e.to_s
  end

  sleep(1)
  doc_wantedly = Nokogiri::HTML.parse(html_wantedly, nil, charset_wantedly)

  doc_wantedly.css('div.projects-index-list > article').each { |div_tag|

    arr = Array.new()

    from_chr = "\u{301C 2212 00A2 00A3 00AC 2013 2014 2016 203E 00A0 00F8 203A 3231 FF5E 878A}"
    to_chr   = "\u{FF5E FF0D FFE0 FFE1 FFE2 FF0D 2015 2225 FFE3 0020 03A6 3009 878A 301C ADEA}"

    company_url = 'https://www.wantedly.com/' + div_tag.css('.company-name.company-without-prefecture > h3 > a').attr('href').value

    title = div_tag.css('.project-index-single-inner > .project-detail > h1 > a').text
    title.tr(from_chr, to_chr)
    title.encode("Shift_JIS","UTF-8",:invalid => :replace,:undef=>:replace).encode("UTF-8","Shift_JIS")

    link = 'https://www.wantedly.com/' + div_tag.css('.project-index-single-inner > .project-detail > h1 > a').attr('href').value
    link.tr(from_chr, to_chr)
    link.encode("Shift_JIS","UTF-8",:invalid => :replace,:undef=>:replace).encode("UTF-8","Shift_JIS")

    company_name = div_tag.css('.company-name.company-without-prefecture > h3 > a').text
    company_name.tr(from_chr, to_chr)
    company_name.encode("Shift_JIS","UTF-8",:invalid => :replace,:undef=>:replace).encode("UTF-8","Shift_JIS")

    html_wantedly_company = open(company_url, "User-Agent" => user_agent_wantedly) do |f|
      charset_wantedly = f.charset
      f.read
    end


    doc_wantedly_company = Nokogiri::HTML.parse(html_wantedly_company, nil, charset_wantedly)
    company_domain_url = doc_wantedly_company.css('p.company-url > a').attr('href').value

    arr = [title, link, company_name, company_domain_url]
    arr_global_wantedly.push(arr)
    sleep(1)
  }
end



CSV.open('export_wantedly.csv', 'w', encoding: "Shift_JIS:UTF-8") do |io|
  io << ['タイトル', 'リンク', '社名', '会社URL']

  arr_global_wantedly.each { |element|
    io << element
  }
end