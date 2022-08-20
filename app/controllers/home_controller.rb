class HomeController < ApplicationController

  def split_word(text)
    return if text.blank?
    uri = URI.parse 'https://jlp.yahooapis.jp/MAService/V2/parse'
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    params = {
      "id": "1234-1",
      "jsonrpc": "2.0",
      "method": "jlp.maservice.parse",
      "params": {
        "q": text
      }
    }.to_json
    headers = {"Content-Type": "application/json","User-Agent": "Yahoo AppID:#{Rails.application.credentials.yahoo_api_key}"}
    response = http.post(uri.path, params, headers)
    word_arr = Array.new
    puts "1"*60
    puts response.body
    puts "1"*60
    if response.body.present? && response.code == '200'
      body_json = JSON.parse(response.body)
      body_json["result"]["tokens"].each do |token|
        word_arr << token[0] if token[3] == '名詞'
      end
    else
      return nil
    end
    word_arr
  end

  def top
    @genre = nil
    naive = NaiveBayes.load('machine_learning.rb')
    word_data = split_word(params[:search]) # 名詞のみ配列で抽出
    puts "2"*60
    puts word_data
    puts "2"*60
    if word_data.present?
      genre_array = naive.classify(*word_data)
      puts "3"*60
      puts genre_array
      puts "3"*60
      case genre_array[0].to_s
      when 'vrgame'
        @genre = "VRゲーム"
      when 'highFantasy'
        @genre = "ハイファンタジー"
      when 'universe'
        @genre = "宇宙"
      when 'panic'
        @genre = "パニック"
      when 'fantasy_science'
        @genre = "空想科学"
      when 'lowfantasy'
        @genre = "ローファンタジー"
      when 'pure_literature'
        @genre = "純文学"
      when 'isekai_romance'
        @genre = "恋愛（異世界）"
      when 'realworld_romance'
        @genre = "恋愛（現実）"
      when 'human_drama'
        @genre = "ヒューマンドラマ"
      when 'detective'
        @genre = "推理"
      end
    end
  end
end
