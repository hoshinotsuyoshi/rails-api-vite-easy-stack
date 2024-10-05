class StaticController < ApplicationController
  def index
    response.headers['Content-Type'] = 'text/html'
    render plain: Rails.root.join("public", "index.html").read, layout: false
  end
end
