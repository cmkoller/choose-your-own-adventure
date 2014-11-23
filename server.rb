require 'sinatra'
require 'csv'

# Creates a hash of adventures, with PAGE_ID --> PAGE_INFO_HASH pairings.
# Within each page's hash, values are:
# => :TITLE, title of page
# => :TEXT, the main story text to be displayed on each page
# => :END_POINT, boolean representing if we're at the end point of the story
# => :ACTIONS, an array of two-item arrays, each representing
# =>  an option-text/destination-id pairing for each option
def process_adventure(filename)
  unprocessed_adventure = CSV.read(filename)
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

  end
  adventure
end


get '/' do
  redirect 'story/1'
end

get '/story/:index' do
  adventure = process_adventure('adventure.csv')

  @index = params[:index]

  @title = adventure[@index][:title]
  @text = adventure[@index][:text]
  @end_point = adventure[@index][:end_point]
  @actions = adventure[@index][:actions]

  erb :index
end

get '/create' do
  @new_submission = true

  # Begin IF loop for retrieving form input
  if params[:title]
    @title = params[:title]
    @author = params[:author]
    filename = "#{@title.gsub(" ", "_")}.csv"


    if File.exist?(filename)
      @new_submission = false
    end


    if @new_submission
      header_info = []
      header_info << @title
      header_info << @author
      # Put HEADER into file
      CSV.open(filename, "a+") do |csv|
        csv << header_info
      end
      @new_submission = false
    end


    page = []
    page << 1
    page << params[:page_header]
    page << params[:page_text]
    @options = [false, false, false, false]
    4.times do |n|
      unless params["opt_#{n + 1}"] == ""
        @options[n] = true
        page << params["opt_#{n + 1}"]
        page << params["id_#{n + 1}"]
      end
    end


    CSV.open(filename, "a+") do |csv|
      csv << page
    end
  end
  # End IF loop for retrieving form input

  # Begin IF loop for printing existing pages
  if File.exist?(filename)
    @adventure = process_adventure(filename)

  end
  # End IF loop for printing existing pages

  erb :new_adventure
end
