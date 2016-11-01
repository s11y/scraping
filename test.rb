# require 'sinatra'
require 'open-uri'
require 'nokogiri'
require 'robotex'
require 'csv'

robotex_green = Robotex.new
p robotex_green.allowed?("https://www.green-japan.com/search_key/01?key=c2rcue2d1cjknwgg9bbc&keyword=")

url_green = 'https://www.green-japan.com/search_key/01?key=c2rcue2d1cjknwgg9bbc&keyword='

user_agent_green = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'
charset_green = nil

html_green = open(url_green, "User-Agent" => user_agent_green) do |f|
  charset_green = f.charset
  f.read
end

doc_green = Nokogiri::HTML.parse(html_green, nil, charset_green)

arr_global_green = Array.new

doc_green.css('.srch-rslt > div').each { |div_tag|
  arr = Array.new()
  arr.push('https://www.green-japan.com' + div_tag.css('a').attr('href').value)
  arr.push(div_tag.css('a > .card-info__heading-area > h3').text)
  arr.push(div_tag.css('a > .card-info__detail-area > .card-info__detail-area__box > .card-info__detail-area__box__heading > h3').text)
  # arr_link.push(div_tag.css('a').attr('href').value)
  # arr_company.push(div_tag.css('a > .card-info__heading-area > h3').text)
  # arr_title.push(div_tag.css('a > .card-info__detail-area > .card-info__detail-area__box > .card-info__detail-area__box__heading > h3').text)

  arr_global_green.push(arr)
}

csv = CSV.open('export.csv', 'w', encoding: "Shift_JIS:UTF-8") do |io|
  io << ['リンク', 'タイトル', '社名']

  arr_global_green.each { |element|
    io << element
  }
end


robotex_wantedly = Robotex.new
p robotex_wantedly.allowed?("https://www.wantedly.com/projects?type=mixed&project%5Bkeyword%5D=")

url_wantedly = "https://www.wantedly.com/projects?type=mixed&project%5Bkeyword%5D="

user_agent_wantedly = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'
charset_wantedly = nil


html_wantedly = open(url_wantedly, "User-Agent" => user_agent_wantedly) do |f|
  charset_wantedly = f.charset
  f.read
end

doc_wantedly = Nokogiri::HTML.parse(html_wantedly, nil, charset_wantedly)

arr_global_wantedly = Array.new()

doc_wantedly.css('div.projects-index-list > article').each { |div_tag|

  arr = Array.new()
  company_url = 'https://www.wantedly.com/' + div_tag.css('.company-name.company-without-prefecture > h3 > a').attr('href').value


  arr.push(div_tag.css('.project-index-single-inner > .project-detail > h1 > a').text)
  arr.push('https://www.wantedly.com/' + div_tag.css('.project-index-single-inner > .project-detail > h1 > a').attr('href').value)
  arr.push(div_tag.css('.company-name.company-without-prefecture > h3 > a').text)

  html_wantedly_company = open(company_url, "User-Agent" => user_agent_wantedly) do |f|
    charset_wantedly = f.charset
    f.read
  end
  doc_wantedly_company = Nokogiri::HTML.parse(html_wantedly_company, nil, charset_wantedly)
  arr.push(doc_wantedly_company.css('p.company-url > a').attr('href').value)

  arr_global_wantedly.push(arr)

}

CSV.open('export_wantedly.csv', 'w', encoding: "Shift_JIS:UTF-8") do |io|
  io << ['リンク', 'タイトル', '社名', '会社URL']

  arr_global_wantedly.each { |element|
    io << element
  }
end