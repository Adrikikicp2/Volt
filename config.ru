# config.ru
require_relative 'app/volt' # Replace with your app file

# Run your Rack app (any object responding to `call`)
run VoltApp.new