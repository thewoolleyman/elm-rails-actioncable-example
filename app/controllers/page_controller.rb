class PageController < ApplicationController
  def show
    if request.host == 'localhost'
      redirect_to("http://127.0.0.1:#{request.port}")
    end
  end
end
