require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require './helpers/UploadHelper'


enable :sessions
set :environment, :production

APP_CONFIG = YAML::load(IO.read("./config/config.yml"))

OUT_DIR = APP_CONFIG['development']['out_dir']
SCP_USER = APP_CONFIG['development']['scp_user']
UPLOAD_SERVERS = APP_CONFIG['development']['upload_servers']
UPLOAD_DIR = APP_CONFIG['development']['upload_dir']

def auth(user_id)
  redirect "/login" unless user_id != nil
end

def generate_user_id()
  return 1 + Random.rand(100)
end


get '/' do
  auth(session[:user_id])
  redirect '/upload'
end

get '/login' do
  erb :login
end

post '/login' do
  user = params[:user]
  if user[:username] == 'uploader' && user[:password] == '12345'
    session[:user_id] = generate_user_id
    redirect '/upload'
  else
    redirect '/invalid_login'
  end
end

get '/invalid_login' do
  erb :invalid_login
end

get '/logout' do
  session.clear
  redirect '/login'
end

get '/upload/?' do
  auth(session[:user_id])
  erb :upload
end

post '/upload/?' do
  auth(session[:user_id])

  # Checks if any file was selected for upload
  unless params[:file] &&
         (tmpfile = params[:file][:tempfile]) &&
         (filename = params[:file][:filename])
    flash[:error] = "No file selected for upload"
    redirect '/upload/'
  end

  # Save file
  target = "#{OUT_DIR}/#{filename}"
  File.open(target, 'wb') {|f| f.write tmpfile.read }

  # Upload file
  if UploadHelper.upload_file(target, filename, UPLOAD_SERVERS, SCP_USER, UPLOAD_DIR)
    flash[:success] = "Upload of #{filename} was successful!"
  else
    flash[:error] = "Upload of #{filename} was unsuccessful! Please contact an admin!"
  end

  redirect '/upload/'

end
