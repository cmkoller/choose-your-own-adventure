require 'csv'
require 'pg'
require 'sinatra'
require 'sinatra/activerecord'
require 'pry'

require_relative 'models/story'
require_relative 'models/page'

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
  @stories = Story.all
  erb :stories
end

post '/stories' do
  if params[:delete]
    # FIGURE OUT HOW TO SANATIZE THIS
    Story.delete([params[:delete]])
    redirect '/stories'
  elsif params[:edit]
    redirect "/create/#{params[:edit]}"
  end
end

get '/story/:index' do
  redirect "/story/#{params[:index]}/1"
end

get '/story/:index/:page' do
  story_id = params[:index]
  page_id = params[:page]

  # SANATIZE THIS
  @story = Story.find(story_id)
  @page = Page.where("story_id = ?", story_id).find(page_id)

  @actions = {@page.action1 => @page.dest1,
    @page.action2 => @page.dest2,
    @page.action3 => @page.dest3,
    @page.action4 => @page.dest4}
  @actions.delete_if { |k, v| k.nil? || v.nil? }
  if @actions.empty?
    @end_point = true
  else
    @end_point = false
  end

  erb :story_view
end

get '/create' do
  erb :new_story
end

post '/create' do
  title = params[:title]
  author = params[:author]
  story = Story.create(title: title, author: author)
  id = story.id
  redirect "/create/#{id}"
end

get '/create/:story_id' do
  @id = params[:story_id]
  @story = Story.find(@id)
  @pages = Page.where(story_id: @id)

  erb :new_page
end

post '/create/:story_id' do
  @id = params[:story_id]
  if params[:delete]
    # SANATIZE THIS
    Page.delete(params[:delete])
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
    Page.create({page_header: page_header, page_body: page_body,
      action1: action1, dest1: dest1, action2: action2, dest2: dest2,
      action3: action3, dest3: dest3, action4: action4, dest4: dest4,
      story_id: story_id, page_num: page_num})
  end

  # Redirect to display the page
  redirect "/create/#{params[:story_id]}"
end
