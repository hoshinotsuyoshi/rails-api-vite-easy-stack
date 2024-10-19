class StaticController < ApplicationController
  def index
    response.headers['Content-Type'] = 'text/html'
    render plain: Rails.public_path.join('index.html').read, layout: false
  end
end
