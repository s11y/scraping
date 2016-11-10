require 'open-uri'
require 'nokogiri'
require 'robotex'
require 'csv'
require 'timeout'

robotex_green = Robotex.new
p robotex_green.allowed?("https://www.green-japan.com/search_key/01?key=c2rcue2d1cjknwgg9bbc&keyword=")

url_green = 'https://www.green-japan.com/search_key/01?key=c2rcue2d1cjknwgg9bbc&keyword='

user_agent_green = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'
charset_green = nil



arr_global_green = Array.new()

for num in 1...188 do
  puts num
  url = url_green + '&page=' + num.to_s

  html_green = open(url, "User-Agent" => user_agent_green) do |f|
    charset_green = f.charset
    f.read
  end

  doc_green = Nokogiri::HTML.parse(html_green, nil, charset_green)

  doc_green.css('.srch-rslt > div').each { |div_tag|
    arr = Array.new()
    from_chr = "\u{301C 2212 00A2 00A3 00AC 2013 2014 2016 203E 00A0 00F8 203A}"
    to_chr   = "\u{FF5E FF0D FFE0 FFE1 FFE2 FF0D 2015 2225 FFE3 0020 03A6 3009}"

    url = 'https://www.green-japan.com' + div_tag.css('a').attr('href').value
    url.tr!(from_chr, to_chr)
    url = url.encode("Shift_JIS","UTF-8",:invalid => :replace,:undef=>:replace).encode("UTF-8","Shift_JIS")
    title = div_tag.css('a > .card-info__heading-area > h3').text
    title.tr!(from_chr, to_chr)
    title = title.encode("Shift_JIS","UTF-8",:invalid => :replace,:undef=>:replace).encode("UTF-8","Shift_JIS")
    company_name = div_tag.css('a > .card-info__detail-area > .card-info__detail-area__box > .card-info__detail-area__box__heading > h3').text
    company_name.tr!(from_chr, to_chr)
    company_name = company_name.encode("Shift_JIS","UTF-8",:invalid => :replace,:undef=>:replace).encode("UTF-8","Shift_JIS")

    arr = [url, title, company_name]

    arr_global_green.push(arr)
  }

end

csv = CSV.open('export.csv', 'w', encoding: "Shift_JIS:UTF-8") do |io|
  io << ['リンク', 'タイトル', '社名']

  arr_global_green.each { |element|
    io << element

  }
end
