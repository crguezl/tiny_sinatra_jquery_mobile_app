#!/usr/bin/env ruby
%w(sinatra sqlite3 dm-sqlite-adapter data_mapper haml time).each{|g| require g}

########## MODELS
class Event
  include DataMapper::Resource
  property :id, Serial
  property :time, DateTime
  property :type, String
  property :description, String
end

########## PERSISTENCE
DataMapper::setup(:default,"sqlite3:pilltracker.db")
DataMapper.finalize.auto_upgrade!

########## CONTROLLERS / ROUTES
get '/' do
  @events = Event.all(:order => :time.desc)
  haml :index
end

get '/new/?' do
  haml :new
end

post '/new/?' do
  begin
    Event.create(
      :time        => Time.parse(params['time']),
      :type        => params['type'],
      :description => params['description']
    )
    redirect '/'
  rescue
    haml :new
  end
end

########## VIEWS
__END__


