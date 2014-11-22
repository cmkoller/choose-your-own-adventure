require 'sinatra'
require 'csv'

unprocessed_adventure = CSV.read('adventure.csv')

adventure = {}

unprocessed_adventure.each do |page|
  index = page[0]
  title = page[1]
  text = page[2]
  actions = page[3..-1]

  adventure[index] = {}
  current = adventure[index]

  current[:title] = title
  current[:text] = text
  current[:end_point] = actions.empty?
  current[:actions] = []

  unless current[:end_point]
    count = 0
    while count <= actions.length - 1
      current[:actions] << [actions[count], actions[count + 1]]
      count += 2
    end
  end

  adventure
end


get '/' do
  redirect 'story/1'
end

get '/story/:index' do
  @index = params[:index]

  @title = adventure[@index][:title]
  @text = adventure[@index][:text]
  @end_point = adventure[@index][:end_point]
  @actions = adventure[@index][:actions]

  erb :index
end

post '/create' do
  @new_submission = true
  if params[:title]
    @new_submission = false

    if @new_submission
      # file = CREATE NEW FILE
      header_info = []
      header_info << params[:title]
      header_info << params[:author]
      # Put HEADER into file
    else
      # file = READ FILE HERE
    end

    page = []
    page << 1
    page << params[:page_header]
    page << params[:page_text]
    4.times do |n|
      if params["opt_#{n + 1}"]
        page << params["opt_#{n + 1}"]
        page << params["id_#{n + 1}"]
      end
    end
  # Put PAGE into file
  end

  # Set
  redirect '/create'
end

get '/create' do
  erb :new_adventure
end
