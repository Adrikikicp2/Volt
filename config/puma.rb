# config/puma.rb
port ENV.fetch("PORT") { 3000 }  # Default to 3000 if PORT isn't set
workers 2
threads 1, 4

app_dir = File.expand_path("../..", __FILE__)
directory app_dir