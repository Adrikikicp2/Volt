require 'erb'
require 'rack/mime'
require 'pathname'  # Add this line

class VoltApp
  ASSET_TYPES = {
    js: 'js',
    css: 'css',
    images: 'images'
  }.freeze

    def call(env)
   
      asset_response = serve_asset(env)
    return asset_response unless asset_response[0] == 404

        request = Rack::Request.new(env)
        erb_html_name = request.path_info == '/' ? 'index' : request.path_info.gsub('/', '')
        erb_html_path = File.expand_path("views/#{erb_html_name}.html.erb", __dir__)
        if File.exist?(erb_html_path)
       
            erb_html = ERB.new(File.read(erb_html_path))
            content = erb_html.result(binding)
            [200, {'Content-Type' => 'text/html'}, [content]]
          else
            [404, {'Content-Type' => 'text/html'}, ["Not Found"]]
          end
    end

    private

  
    def serve_asset(env)
      request = Rack::Request.new(env)
      path = request.path_info
      
      return [404, {}, ['']] unless path.start_with?('/assets/')
      
      parts = path.gsub('/assets/', '').split('/')
      return forbidden_response if parts.size < 2
      
      asset_type = parts[0].to_sym
      filename = parts[1..].join('/')
      
      serve_asset_file(asset_type, filename)
    end
  
    def serve_asset_file(type, filename)
      return forbidden_response unless ASSET_TYPES.key?(type)
    
      # Correct base path calculation
      base_dir = File.expand_path('../app/assets', __dir__)
      asset_dir = ASSET_TYPES[type]
      full_path = File.join(base_dir, asset_dir, filename)
    
      begin
        requested_path = Pathname.new(full_path).cleanpath
        base_pathname = Pathname.new(base_dir)
    
        # Debugging output
        puts "[Asset Request] Looking for: #{requested_path}"
        puts "[Asset Request] Base directory: #{base_pathname}"
    
        if requested_path.to_s.start_with?(base_pathname.to_s) && File.file?(requested_path)
          content = File.read(requested_path)
          mime_type = Rack::Mime.mime_type(File.extname(filename))
          [200, {'Content-Type' => mime_type}, [content]]
        else
          puts "[Asset Request] Path traversal attempt or file not found"
          forbidden_response
        end
      rescue StandardError => e
        puts "[Asset Error] #{e.message}"
        forbidden_response
      end
    end

  
  def helpers
    binding
  end
  
  def asset_url(filename, type)
    "/assets/#{ASSET_TYPES[type]}/#{filename}"
  end

  def javascript_tag(name)
    %(<script src="#{asset_url(name, :js)}"></script>)
  end

  def stylesheet_tag(name)
    %(<link rel="stylesheet" href="#{asset_url(name, :css)}">)
  end

  def image_tag(name, alt: "")
    %(<img src="#{asset_url(name, :images)}" alt="#{alt}">)
  end
  def forbidden_response
    [403, {'Content-Type' => 'text/plain'}, ['Forbidden']]
  end
end