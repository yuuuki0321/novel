class HomeController < ApplicationController
  def top
    puts "aa"*60
    puts params[:search]
  end
end
