module Rack
  class Delay
    HEADER = 'X-Rack-Delay'

    attr_reader :app, :options

    def initialize(app, options={})
      @app     = app
      
      if options.has_key?(:unless)
        options[:if] = options.delete(:unless)
        options[:negate] = true
      end

      @options = {
          :min    => 50,     # msec
          :max    => 5000,   # msec
          :delay  => nil,
          :if     => nil,
          :negate => false
        }.merge(options)
    end

    def peek_delay(min, max)
      return min / 1000.0 if min == max
      (min + rand(max - min)) / 1000.0
    end

    def _call_block(block, request)
      if block.arity == 0
        block.call()
      else
        block.call(request)
      end
    end

    def call(env)
      request = Rack::Request.new(env)
      skip_delay = false
      
      
      skip_delay = !!_call_block(options[:if], request) if options[:if]
      skip_delay = !skip_delay if options[:negate]

      header_delay = 'none'
      
      unless skip_delay

        min_delay = options[:min]
        max_delay = options[:max]

        if options[:delay]
          ret = _call_block(options[:delay], request)
          ret = [ret] unless ret.kind_of?(Array)
          min_delay = ret.first
          max_delay = ret.last
        end

        delay = peek_delay(min_delay, max_delay)
        header_delay = delay
        sleep(delay)
      end
      
      status , headers , response = app.call(env)
      headers[ HEADER ] = header_delay.to_s
      [status , headers , response]
    end
  end

end