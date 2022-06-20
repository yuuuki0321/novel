require 'open-uri'
# スクレイピングのgem
require 'nokogiri'
require 'mysql2'
require 'active_record'
class NovelInformation < ActiveRecord::Base
end

#DB接続設定
ActiveRecord::Base.establish_connection(
 adapter:  "mysql2",
 host:     "127.0.0.1", #ローカルのDBに接続します。
 username: "root", #ユーザー名
 password: "",  #設定したMySQLのパスワード
 database: "noveldata",  #接続したいDB名
)
#url = 'https://yomou.syosetu.com/rank/genrelist/type/yearly_401/'
50.times do |i|
  sleep 10
  url = "https://yomou.syosetu.com/search.php?order=hyoka&genre=202&p=#{i}"
  res = open(url)
  body = res.read
  charset = res.charset
  html = Nokogiri::HTML.parse(body, nil, charset)
  html.search('div.searchkekka_box').each do |node|
    title = node.css('.tl').text
    synopsis = node.css('.ex').text
    genre = 'Fantasy'
    sub_genre = 'lowfantasy'
    next if title.blank?
    NovelInformation.create(genre:genre, sub_genre:sub_genre, title: title, synopsis: synopsis)
  end
end
