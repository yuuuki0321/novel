require 'natto'
require 'naive_bayes'
require 'mysql2'
require 'active_record'

class NovelInformation < ActiveRecord::Base
end

ActiveRecord::Base.establish_connection(
 adapter:  "mysql2",
 host:     "127.0.0.1", #ローカルのDBに接続します。
 username: "root", #ユーザー名
 password: "",  #設定したMySQLのパスワード
 database: "noveldata",  #接続したいDB名
)

# テキストを単語の配列にする
def split_word(text)
  natto = Natto::MeCab.new
  word_arr = Array.new
  natto.parse(text) do |parsed_word|
    # 名詞のみ抽出
    word_arr << parsed_word.surface if parsed_word.feature.split(',')[0] == "名詞"
  end
  word_arr
end

bayes = NaiveBayes.new(:vrgame, :universe)

sub_vrgames = NovelInformation.where(sub_genre: "vrgame")
sub_universes = NovelInformation.where(sub_genre: "universe")
sub_panic = NovelInformation.where(sub_genre: "panic")
sub_lowfantasy = NovelInformation.where(sub_genre: "lowfantasy")
sub_highFantasy = NovelInformation.where(sub_genre: "highFantasy")
sub_fantasy_science = NovelInformation.where(sub_genre: "fantasy_science")

# succerカテゴリの学習
sub_vrgames.each do |vrgame|
  word_array = split_word(vrgame.synopsis)
  # 単語が複数渡せるので配列を展開した状態で引数に渡す
  bayes.train(:vrgame, *word_array)
end

# baseballカテゴリの学習
sub_universes.each do |universe|
  word_array = split_word(universe.synopsis)
  # 単語が複数渡せるので配列を展開した状態で引数に渡す
  bayes.train(:universe, *word_array)
end

sub_panic.each do |panic|
  word_array = split_word(panic.synopsis)
  # 単語が複数渡せるので配列を展開した状態で引数に渡す
  bayes.train(:panic, *word_array)
end

sub_fantasy_science.each do |fantasy_science|
  word_array = split_word(fantasy_science.synopsis)
  # 単語が複数渡せるので配列を展開した状態で引数に渡す
  bayes.train(:fantasy_science, *word_array)
end

sub_lowfantasy.each do |lowfantasy|
  word_array = split_word(lowfantasy.synopsis)
  # 単語が複数渡せるので配列を展開した状態で引数に渡す
  bayes.train(:lowfantasy, *word_array)
end

sub_highFantasy.each do |highFantasy|
  word_array = split_word(highFantasy.synopsis)
  # 単語が複数渡せるので配列を展開した状態で引数に渡す
  bayes.train(:highFantasy, *word_array)
end


# 学習データを保存
bayes.db_filepath = 'machine_learning.rb'
bayes.save
