require 'sqlite3'

def db
    if @db == nil
        @db = SQLite3::Database.new('./db/db.sqlite')
        @db.results_as_hash = true
    end
    return @db
end

def drop_tables
    db.execute('DROP TABLE IF EXISTS fruits')
end

def create_tables

    db.execute('CREATE TABLE albums (
	id INTEGER,
	album_title	NUMERIC NOT NULL,
	year NUMERIC NOT NULL,
	artist_id INTEGER NOT NULL, 
    PRIMARY KEY("id" AUTOINCREMENT)
)')

    db.execute('CREATE TABLE artists (
    id INTEGER,
    name TEXT NOT NULL, 
    PRIMARY KEY("id" AUTOINCREMENT)
)')
    db.execute('CREATE TABLE songs (
	id INTEGER,
	song_title	TEXT NOT NULL,
	album_id	INTEGER,
	PRIMARY KEY("id" AUTOINCREMENT)
)')

    db.execute('CREATE TABLE "songs" (
        id INTEGER,
        song_title INTEGER NOT NULL,
        album_id INTEGER,
        PRIMARY KEY("id" AUTOINCREMENT)
    )')
    db.execute('CREATE TABLE user (
        id INTEGER,
        password TEXT NOT NULL,
        username INTEGER UNIQUE,
        PRIMARY KEY("id" AUTOINCREMENT)
    )')
end




def seed_tables

    albums = [
        {album_title: 'Too Late To Die Young', year: '2022', artist_id:'1'},
        {album_title: 'Intergalactical Janet', year: '2023', artist_id:'2'},
        {album_title: 'TheKAMAKUU-CASSETTE: uRTH GoLD', year: '2017', artist_id:'3'}
    ]

    albums.each do |album|
        db.execute('INSERT INTO albums (album_title, year, artis_id) VALUES (?,?,?)', album[:album_title], album[:year], ablum[:artists_id])
    end

    artists = [
        {id: '1', name: 'Sonder'},
        {id: '2', name: 'Ley Soul'},
        {id: '3', name: 'KAMAKUU'}   
    ]

    artists.each do |artist|
        db.execute('INSERT INTO artists (id, name) VALUES (?,?)', artists[:id], artists[:name])
    end

    songs = [
        {id: '1', song_title: '1', album_id: '1'},
        {id: '2', song_title: '2', album_id: '2'},
        {id: '3', song_titled: '3', album_id: '3'}   
    ]

    songs.each do |song|
        db.execute('INSERT INTO songs (id, song_title, album_id) VALUES (?,?,?)', songs[:id], songs[:song_title], songs[:album_id])
    end

    users = [
        {id: '0', password: 'musick', username: 'Music101'},
    ]

    users.each do |user|
        db.execute('INSERT INTO users (id, password, username) VALUES (?,?,?)', songs[:id], songs[:song_title], songs[:album_id])
    end
    
end

drop_tables
create_tables
seed_tables