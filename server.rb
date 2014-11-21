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
  redirect '/1'
end

get '/:index' do
  @index = params[:index]

  @title = adventure[@index][:title]
  @text = adventure[@index][:text]
  @end_point = adventure[@index][:end_point]
  @actions = adventure[@index][:actions]

  erb :index
end
