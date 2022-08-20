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
    headers = {"Content-Type": "application/json","User-Agent": "Yahoo AppID:dj00aiZpPTFqUDJJQjNOMWZMeCZzPWNvbnN1bWVyc2VjcmV0Jng9ODI-"}
    response = http.post(uri.path, params, headers)
    word_arr = Array.new
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
    @genre_array = nil
    naive = NaiveBayes.load('machine_learning.rb')
    test_data = split_word(params[:search]) # 名詞のみ配列で抽出
    if test_data.present?
      @genre_array = naive.classify(*test_data)
      case @genre_array[0]
      when 'vrgame'
        @genre = "VRゲーム"
      when 'highFantasy'
        @genre = "ハイファンタジー"
      end
    end
  end
end