Rack-delay
==========

A simple rack middleware to add a random delay for requests, so you can simulate network latency during development.
This library works with any rack capable framework, so you can use with sinatra or rails or whatever you want.

## Install

You can install this library via gem

    gem install rack-delay

or via Bundler adding

```ruby
gem 'rack-delay'
```

to your Gemfile and install:

    bundle install


## Usage

To use rack-delay simply add it in config.ru file.
Below is an example of middleware:

```ruby
# config.ru

require 'rack/delay'

use Rack::Delay

app = proc do |env|
  [ 200, {'Content-Type' => 'text/plain'}, "b" ]
end

run app
```

Rack-delay when use without options, will add a random delay to every request.
You probably want to customize this behaviour, so you can pass options to middleware ex:

```ruby
# config.ru

require 'rack/delay'

use Rack::Delay, {
  :min => 0,    # ms
  :max => 5000, # ms
  :if => lambda { |request|
    request.xhr?
  }
}

app = proc do |env|
  [ 200, {'Content-Type' => 'text/plain'}, "b" ]
end

run app
```

In previous example rack-delay will add a random delay (between :min/:max) to every ajax requests.

Also you can do more complex things like use a different delay for different requests, ex:

```ruby
# config.ru

require 'rack/delay'

use Rack::Delay, {
  :delay => lambda { |request|
    if request.get? # fixed 100ms delay to every get request
      [100]
    elsif request.post? # 300ms - 3sec delay to every post request
      [300, 3000]
    else
      [0, rand(5000)] # use a random delay
    end
    
    # if you not return a number from this block, rack-delay will use defaults range :min/:max to calc random delay
  },
  :if => lambda { |request|
    request.xhr? and request.ip == '127.0.0.1'
  }
}

app = proc do |env|
  [ 200, {'Content-Type' => 'text/plain'}, "b" ]
end

run app
```

## Copyright

Copyright (c) 2013 Vincenzo Farruggia.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.