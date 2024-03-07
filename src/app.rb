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
    
    get '/artists/:id' do |artist_id|
        @artists_selected = db.execute('SELECT * FROM artists WHERE id = ?', artist_id.to_i).first
        erb :'show_artists'
    end

    post '/artists/' do 
      name = params['name']
      desc = params['about']
      query = 'INSERT INTO artist (name, about) VALUES (?,?) RETURNING *'
      result = db.execute(query, name, desc).first 
      redirect "/artists/#{result['id']}" 
    end

    get '/fruits/:id/edit' do |id| 
        @fruits = db.execute('SELECT * FROM fruits WHERE id = ?', id.to_i).first
        erb :'edit'
    end 

    post '/fruits/:id/update' do |id| 
        fruit = params['content']
        db.execute('UPDATE fruits SET (content = ?) WHERE id = ?', fruit, id)
        redirect "/fruits/#{id}" 
    end

    post '/fruits/:id/delete' do |id| 
        db.execute('DELETE FROM fruits WHERE id = ?', id)
            redirect "/fruits/"
      end

    get '/fruits/:id' do |fruit_id|
        @fruits_selected = db.execute('SELECT * FROM fruits WHERE id = ?', fruit_id.to_i).first
        erb :show
    end

    

    
end