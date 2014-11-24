require 'sinatra'
require 'csv'

LIST_OF_STORIES = 'list_of_stories.txt'

# Creates a hash of adventures with:
# => :STORY_TITLE
# => :AUTHOR
# => :PAGES, a hash of PAGE_ID (integer) --> PAGE_INFO_HASH pairings;
# =>  one for each page in the story.
# Within each page's hash, values are:
# => :TITLE, title of page
# => :TEXT, the main story text to be displayed on each page
# => :END_POINT, boolean representing if we're at the end point of the story
# => :ACTIONS, an array of two-item arrays, each representing
# =>  an option-text/destination-id pairing for each option
def process_adventure(filename)
  unprocessed_adventure = CSV.read(filename)
  adventure = {}

  meta_info = unprocessed_adventure.shift
  adventure[:story_title] = meta_info[0]
  adventure[:author] = meta_info[1]
  adventure[:pages] = {}
  unprocessed_adventure.each do |page|
    index = page[0]
    title = page[1]
    text = page[2]
    actions = page[3..-1]

    adventure[:pages][index] = {}
    current = adventure[:pages][index]

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
  redirect '/stories'
end

get '/story/:name' do
  redirect "/story/#{params[:name]}/1"
end

get '/story/:name/:index' do
  story_name = params[:name]
  adventure = process_adventure("#{story_name}.csv")

  @index = params[:index]

  @story_title = adventure[:story_title]
  @author = adventure[:author]
  page_info = adventure[:pages][@index]
  @title = page_info[:title]
  @text = page_info[:text]
  @end_point = page_info[:end_point]
  @actions = page_info[:actions]

  erb :story_view
end

get '/create' do
  @new_submission = true
  @new_page_id = 1
  # Begin IF loop for retrieving form input
  if params[:title]
    @title = params[:title]
    @author = params[:author]
    filename = "#{@title.gsub(" ", "_")}.csv"
    @new_page_id = params[:page_id].to_i + 1
    #@page_id = @page_id_start.to_i + 1

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
      File.open(LIST_OF_STORIES, "a") do |file|
        file << "filename\n"
      end
      @new_submission = false
    end


    page = []
    page << @new_page_id - 1
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

    # Begin IF loop for printing existing pages
    if File.exist?(filename)
      @adventure = process_adventure(filename)[:pages].sort_by { |k, v| k }
    end
    # End IF loop for printing existing pages
  end
  # End IF loop for retrieving form input

  erb :new_adventure
end

get '/stories' do
  @stories = File.read(LIST_OF_STORIES).split("\n")
  erb :stories
end
