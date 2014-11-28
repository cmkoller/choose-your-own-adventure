require 'sinatra'
require 'csv'
require 'pg'
require 'pry'

def db_connection
  begin
    connection = PG.connect(dbname: 'adventures')

    yield(connection)

  ensure
    connection.close
  end
end

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
  erb :new_story
end

post '/create' do
  @title = params[:title]
  @author = params[:author]
  db_connection do |connection|
    connection.exec_params("INSERT INTO stories (title, author) VALUES ($1, $2);",
    [@title, @author])
    @id = connection.exec("SELECT currval('stories_id_seq');")
  end

  redirect "/create/#{@id}"
end

get '/create/:story_id' do
  @id = params[:story_id]
  db_connection do |connection|
    story_info = connection.exec_params("SELECT title, author
    FROM stories WHERE id = $1", [@id])
    @title = story_info[0]["title"]
    @author = story_info[0]["author"]
    @info = connection.exec_params("SELECT * FROM pages WHERE story_id = $1",
    [@id])
  end
    # Display info read from PAGES folder if it exists

  erb :new_page
end

post '/create/:story_id' do
  @id = params[:story_id]
  if params[:delete]
    db_connection do |connection|
      connection.exec("DELETE FROM pages WHERE id = #{params[:delete]}")
    end
  else
    # Write the new page to the PAGES database
    page_num = params[:page_id]
    page_header = params[:page_header]
    page_body = params[:page_text]
    story_id = params[:story_id]
    # Option 1
    if params[:opt_1] != ""
      action1 = params[:opt_1]
      dest1 = params[:id_1]
    else
      action1 = NIL
      dest1 = NIL
    end
    # Option 2
    if params[:opt_2] != ""
      action2 = params[:opt_2]
      dest2 = params[:id_2]
    else
      action2 = NIL
      dest2 = NIL
    end
    # Option 3
    if params[:opt_3] != ""
      action3 = params[:opt_3]
      dest3 = params[:id_3]
    else
      action3 = NIL
      dest3 = NIL
    end
    # Option 4
    if params[:opt_4] != ""
      action4 = params[:opt_4]
      dest4 = params[:id_4]
    else
      action4 = NIL
      dest4 = NIL
    end
    db_connection do |connection|
      connection.exec_params("INSERT INTO pages (page_header, page_body, action1,
      dest1, action2, dest2, action3, dest3, action4, dest4, story_id, page_num)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);",
      [page_header, page_body, action1, dest1, action2, dest2, action3, dest3,
        action4, dest4, story_id, page_num])
    end
  end

  # Redirect to display the page
  redirect "/create/#{params[:story_id]}"
end



get '/stories' do
  @stories = File.read(LIST_OF_STORIES).split("\n")
  erb :stories
end
