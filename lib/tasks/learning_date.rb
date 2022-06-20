require 'natto'
require 'naive_bayes'

def split_word(text)
  natto = Natto::MeCab.new
  word_arr = Array.new
  natto.parse(text) do |parsed_word|
    # 名詞のみ抽出
    word_arr << parsed_word.surface if parsed_word.feature.split(',')[0] == "名詞"
  end
  word_arr
end

naive = NaiveBayes.load('machine_learning.rb')
# 同じように名詞のみ配列で抽出
test_data = split_word("世に100の神ゲーあれば、世に1000のクソゲーが存在する。 バグ、エラー、テクスチャ崩壊、矛盾シナリオ………大衆に忌避と後悔を刻み込むゲームというカテゴリにおける影。 そんなクソゲーをこよなく愛する少年が、ちょっとしたきっかけから大衆が認めた神ゲーに挑む。 それによって少年を中心にゲームも、リアルも変化し始める。だが少年は今日も神ゲーのスペックに恐れおののく。 「岩にちゃんと当たり判定がある……！！」 週刊少年マガジンでコミカライズが連載中です。")
puts naive.classify(*test_data)
#=>succer
#  5.340087318989427e-10
