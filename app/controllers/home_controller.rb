class HomeController < ApplicationController
  
  def split_word(text)
    natto = Natto::MeCab.new
    word_arr = Array.new
    if text.present?
      natto.parse(text) do |parsed_word|
        word_arr << parsed_word.surface if parsed_word.feature.split(',')[0] == "名詞" # 名詞のみ抽出
      end
    else
      return nil
    end
    word_arr
  end

  def top
    @genre = nil
    naive = NaiveBayes.load('machine_learning.rb')
    test_data = split_word(params[:search]) # 名詞のみ配列で抽出
    if test_data.present?
      @genre = naive.classify(*test_data)
    end
  end
end