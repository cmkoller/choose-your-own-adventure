require 'sinatra'
require 'csv'
require 'pg'

def db_connection
  begin
    connection = PG.connect(dbname: 'adventures')

    yield(connection)

  ensure
    connection.close
  end
end

get '/' do
  redirect '/stories'
end

get '/stories' do
  db_connection do |connection|
    @stories = connection.exec("SELECT * FROM stories")
  end
  erb :stories
end

post '/stories' do
  db_connection do |connection|
    connection.exec_params("DELETE FROM stories WHERE id = $1",
    [params[:delete]])
  end
  redirect '/stories'
end

get '/story/:index' do
  redirect "/story/#{params[:index]}/1"
end

get '/story/:index/:page' do
  story_index = params[:index]
  page = params[:page]

  db_connection do |connection|
    info = connection.exec_params("SELECT
      FROM pages.page_header, pages.page_body, pages.action1, pages.dest1,
      pages.action2, pages.dest2, pages.action3, pages.dest3, pages.action4,
      pages.dest5, stories.title AS story_title, stories.author
      JOIN pages ON stories.id = pages.story_id
      WHERE stories.id = $1 AND pages.page_num = $2",
    [story_index, page])

    @story_title = info[0]["story_title"]
    @author = info[0]["author"]
    @page_header = info[0]["page_header"]
    @text = info[0]["page_body"]
    @actions = [info[0]["action1"], info[0]["dest1"], info[0]["action2"],
    info[0]["dest2"], info[0]["action3"], info[0]["dest3"], info[0]["action4"],
    info[0]["dest4"]]
    @actions.delete(NIL)
    if @actions.empty?
      @end_point = true
    else
      @end_point = false
    end
  end

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
    @id = connection.exec("SELECT currval('stories_id_seq') AS id;").first["id"]
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

  erb :new_page
end

post '/create/:story_id' do
  @id = params[:story_id]
  if params[:delete]
    db_connection do |connection|
      connection.exec_params("DELETE FROM pages WHERE id = $1",
      [params[:delete]])
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
