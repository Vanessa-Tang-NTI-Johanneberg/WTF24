class App < Sinatra::Base

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
      name = params['name']
      desc = params['about']
      query = 'INSERT INTO artists (name, about) VALUES (?,?) RETURNING *'
      result = db.execute(query, name, desc).first 
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

    post '/artists/:id/delete' do |id| 
        db.execute('DELETE FROM artists WHERE id = ?', id)
            redirect "/artists/"
    end

    get '/artists/:id' do |artist_id|
        @artists_selected = db.execute('SELECT * FROM artists WHERE id = ?', artist_id.to_i).first
        erb :'show_artists'
    end

    

    
end