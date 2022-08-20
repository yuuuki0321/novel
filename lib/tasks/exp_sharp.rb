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

bayes = NaiveBayes.new(:vrgame, :universe, :panic, :fantasy_science, :lowfantasy, :highFantasy, :pure_literature, :isekai_romance, :realworld_romance, :human_drama, :detective)

sub_vrgames = NovelInformation.where(sub_genre: "vrgame")
sub_universes = NovelInformation.where(sub_genre: "universe")
sub_panic = NovelInformation.where(sub_genre: "panic")
sub_fantasy_science = NovelInformation.where(sub_genre: "fantasy_science")
sub_lowfantasy = NovelInformation.where(sub_genre: "lowfantasy")
sub_highFantasy = NovelInformation.where(sub_genre: "highFantasy")
sub_pure_literature = NovelInformation.where(sub_genre: "pure_literature")
sub_isekai_romance = NovelInformation.where(sub_genre: "isekai_romance")
sub_realworld_romance = NovelInformation.where(sub_genre: "realworld_romance")
sub_human_drama = NovelInformation.where(sub_genre: "human_drama")
sub_detective = NovelInformation.where(sub_genre: "detective")


sub_vrgames.each do |vrgame|
  word_array = split_word(vrgame.synopsis)
  bayes.train(:vrgame, *word_array)
end

sub_universes.each do |universe|
  word_array = split_word(universe.synopsis)
  bayes.train(:universe, *word_array)
end

sub_panic.each do |panic|
  word_array = split_word(panic.synopsis)
  bayes.train(:panic, *word_array)
end

sub_fantasy_science.each do |fantasy_science|
  word_array = split_word(fantasy_science.synopsis)
  bayes.train(:fantasy_science, *word_array)
end

sub_lowfantasy.each do |lowfantasy|
  word_array = split_word(lowfantasy.synopsis)
  bayes.train(:lowfantasy, *word_array)
end

sub_highFantasy.each do |highFantasy|
  word_array = split_word(highFantasy.synopsis)
  bayes.train(:highFantasy, *word_array)
end

sub_pure_literature.each do |pure_literature|
  word_array = split_word(pure_literature.synopsis)
  bayes.train(:pure_literature, *word_array)
end

sub_pure_literature.each do |isekai_romance|
  word_array = split_word(isekai_romance.synopsis)
  bayes.train(:isekai_romance, *word_array)
end

sub_pure_literature.each do |realworld_romance|
  word_array = split_word(realworld_romance.synopsis)
  bayes.train(:realworld_romance, *word_array)
end

sub_pure_literature.each do |human_drama|
  word_array = split_word(human_drama.synopsis)
  bayes.train(:human_drama, *word_array)
end

sub_pure_literature.each do |detective|
  word_array = split_word(detective.synopsis)
  bayes.train(:detective, *word_array)
end


# 学習データを保存
bayes.db_filepath = 'machine_learning.rb'
bayes.save
