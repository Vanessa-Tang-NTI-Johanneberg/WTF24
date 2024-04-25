

class App < Sinatra::Base

    helpers do

        def h(text)
            Rack::Utils.escape_html(text)
        end
    end

    def db
        if @db == nil
            @db = SQLite3::Database.new('./db/db.sqlite')
            @db.results_as_hash = true
        end
        return @db
    end

    get '/' do
        erb :index
    end

    get '/artists' do
        @artists = db.execute('SELECT * FROM artists')
        erb :artists
    end

    get '/artists/new' do 
        erb :'new'
    end

    post '/artist/add' do 
      p params
      name = params['name']
      desc = params['about']
      score = params['rating']
      query = 'INSERT INTO artists (name, about, raiting) VALUES (?,?,?) RETURNING *'
      result = db.execute(query, name, desc, score).first 
      redirect "/artists" 
    end

    get '/artists/:id/edit' do |id| 
        @artists = db.execute('SELECT * FROM artists WHERE id = ?', id.to_i).first
        erb :'edit'
    end 

    post '/artists/:id/update' do |id| 
        artist = params['content']
        db.execute('UPDATE artists SET (content = ?) WHERE id = ?', artist, id)
        redirect "/artists/#{id}" 
    end

    post '/artist/delete/:id' do |id| 
        db.execute('DELETE FROM artists WHERE id = ?', id)
        redirect "/artists"
    end

    get '/artists/:id' do |artist_id|
        @artists_selected = db.execute('SELECT * FROM artists WHERE id = ?', artist_id.to_i).first
        erb :'show_artists'
    end

    get '/login' do
        "Hello World"
        erb :'login'

    end

    
end