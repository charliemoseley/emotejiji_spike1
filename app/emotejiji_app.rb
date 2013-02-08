require 'app/models/init'
require 'app/relationships/init'
require 'app/api/init'
require 'app/views/init'

module Emotejiji
  class App
    def initialize
      @filenames = [ '', '.html', 'index.html', '/index.html' ]
      @rack_static = ::Rack::Static.new(
        lambda { [404, {}, []] }, {
          :root => File.expand_path('../../public', __FILE__),
          :urls => %w[/]
        })
    end

    def call(env)
      # api
      response = Emotejiji::API.call(env)

      # Check if the App wants us to pass the response along to others
      if response[1]['X-Cascade'] == 'pass'
        # static files
        request_path = env['PATH_INFO']
        @filenames.each do |path|
          response = @rack_static.call(env.merge({'PATH_INFO' => request_path + path}))
          return response if response[0] != 404
        end
      end

      # Serve error pages or respond with API response
      case response[0]
      when 404, 500
        @rack_static.call(env.merge({'PATH_INFO' => "/errors/#{response[0]}.html"}))
      else
        response
      end
    end
  end
end


