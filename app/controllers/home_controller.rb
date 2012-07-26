class HomeController < ApplicationController
  def index
    @calls = Call.all
  end
end
