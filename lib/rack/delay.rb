module Rack
  class Delay
    attr_reader :app, :options

    def initialize(app, options={})
      @app     = app
      @options = {
          :min => 0,      # msec
          :max => 5000,   # msec
          :delay => nil,
          :if => nil
        }.merge(options)
    end

    def peek_delay(min, max)
      return min / 1000.0 if min == max
      (min + rand(max - min)) / 1000.0
    end

    def call(env)
      request = Rack::Request.new(env)
      skip_delay = !!options[:if].call(request) if options[:if]
      
      unless skip_delay

        min_delay = options[:min]
        max_delay = options[:max]

        if options[:delay]
          ret = options[:delay].call(request)
          ret = [ret] unless ret.kind_of?(Array)
          min_delay = ret.first
          max_delay = ret.last
        end

        delay = peek_delay(min_delay, max_delay)
        sleep(delay)
      end
      
      app.call(env)
      
      Thread.current[:skip_delay] = false
    end
  end

end