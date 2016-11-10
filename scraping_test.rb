require 'open-uri'
require 'nokogiri'
require 'robotex'
require 'csv'
require 'timeout'

def sjis_safe(str)
  [
      ["301C", "FF5E"], # wave-dash
      ["2212", "FF0D"], # full-width minus
      ["00A2", "FFE0"], # cent as currency
      ["00A3", "FFE1"], # lb(pound) as currency
      ["00AC", "FFE2"], # not in boolean algebra
      ["2014", "2015"], # hyphen
      ["2016", "2225"], # double vertical lines
  ].inject(str) do |s, (before, after)|
    s.gsub(
        before.to_i(16).chr('UTF-8'),
        after.to_i(16).chr('UTF-8'))
  end
end

robotex_wantedly = Robotex.new
p robotex_wantedly.allowed?("https://www.wantedly.com/projects?type=mixed")

url_wantedly = "https://www.wantedly.com/projects?type=mixed"

user_agent_wantedly = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'
charset_wantedly = nil


arr_global_wantedly = Array.new()

for page_number in 1599...1657 do
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
    # from_chr = "\u{301C 2212 00A2 00A3 00AC 2013 2014 2016 203E 00A0 00F8 203A}"
    # to_chr   = "\u{FF5E FF0D FFE0 FFE1 FFE2 FF0D 2015 2225 FFE3 0020 03A6 3009}"

    company_url = 'https://www.wantedly.com/' + div_tag.css('.company-name.company-without-prefecture > h3 > a').attr('href').value
    # company_url.tr!(from_chr, to_chr)

    title = div_tag.css('.project-index-single-inner > .project-detail > h1 > a').text
    # title.tr!(from_chr, to_chr)
    # title.encode(Encoding::SJIS,:invalid => :replace,:undef=>:replace,:replace => "*").encode("UTF-8","Shift_JIS")
    title.encode(Encoding::SJIS, :invalid=>:replace, :undef=>:replace)
    # title = sjis_safe(title).encode(Encoding::SJIS)

    link = 'https://www.wantedly.com/' + div_tag.css('.project-index-single-inner > .project-detail > h1 > a').attr('href').value
    # link.tr!(from_chr, to_chr)
    # link.encode("Shift_JIS","UTF-8",:invalid => :replace,:undef=>:replace, :replace => "*").encode("UTF-8","Shift_JIS")
    # link.encode(Encoding::SJIS,:invalid => :replace,:undef=>:replace, :replace => "*").encode("UTF-8","Shift_JIS")
    # link = sjis_safe(link).encode(Encoding::SJIS)
    link.encode(Encoding::SJIS, :invalid => :replace, :undef => :replace)

    company_name = div_tag.css('.company-name.company-without-prefecture > h3 > a').text
    # company_name.tr!(from_chr, to_chr)
    # company_name.encode(Encoding::SJIS,:invalid => :replace,:undef=>:replace, :replace=>"*").encode("UTF-8","Shift_JIS")
    # company_name = sjis_safe(company_name).encode(Encoding::SJIS)
    company_name.encode(Encoding::SJIS, :invalid => :replace, :undef => :replace)

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

CSV.open('export_wantedly_test.csv', 'w', encoding: "Shift_JIS:UTF-8") do |io|
  io << ['タイトル', 'リンク', '社名', '会社URL']

  arr_global_wantedly.each { |element|
    io << element
  }
end


