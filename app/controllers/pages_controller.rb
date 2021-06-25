class PagesController < ApplicationController

  def home
    @count = Member.count
  end

  def how
  end

end