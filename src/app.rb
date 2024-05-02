

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
      query = 'INSERT INTO artists (name, about, rating) VALUES (?,?,?) RETURNING *'
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

    get '/user/:id' do |user_id|
        @user = db.execute('SELECT * FROM users WHERE id = ?', user_id).first
        erb :'userpage'
    end

    get '/new_account' do
        erb :'new_account'
    end

    # 'post '/new_account' do
    #     username = params['username']
    #     cleartext_password = params['password']
    #     hashed_password = BCrypt::Password.create(cleartext_password) 
    #     user = db.execute('INSERT INTO users (username, password) VALUES (?,?) RETURNING *', username, hashed_password).first['id']
    #     session[:user_id] = id
    #     redirect '/new_account'
    # end'

    post '/new_account' do
        name = params['user_name']
        password = params['password']
        hashed_password = BCrypt::Password.create(password)
        id = db.execute('INSERT INTO users (name, password) VALUES (?,?) RETURNING *', name, hashed_password).first['id']
        session[:user_id] = id
        redirect "/user/#{id}" 
    end


    #Sida 1.1 Skapa konto/logga in 
    get '/user/:id' do |user_id|  
        @user = db.execute('SELECT * FROM users WHERE id = ?', user_id).first
        erb :'userpage'
    end

    get '/login' do
        erb :'login'
    end

    post '/login' do 
        username = params['username']
        cleartext_password = params['password'] 
        password_from_db = BCrypt::Password.new(user['password'])
        user = db.execute('INSERT INTO users (username, password) VALUES (?,?) RETURNING *', username, hashed_password).first['id']
        
        if 
            user == nil
            redirect '/new_account'
        end

        if password_from_db == clertext_password 
            session[:user_id] = user['id']
            redirect "/user/#{session[:user_id]}"
        else
            p "Failed login"
            redirect "/index"
        end
    end
    
end