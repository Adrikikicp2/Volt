require 'erb'

class VoltApp
    def call(env)
        request = Rack::Request.new(env)
        erb_html_name = request.path_info == '/' ? 'index' : request.path_info.gsub('/', '')
        erb_html_path = File.expand_path("views/#{erb_html_name}.html.erb", __dir__)
        if File.exist?(erb_html_path)
            # Render template with variables
            erb_html = ERB.new(File.read(erb_html_path))
            content = erb_html.result(binding)
            [200, {'Content-Type' => 'text/html'}, [content]]
          else
            [404, {'Content-Type' => 'text/html'}, ["Not Found"]]
          end
    end

end