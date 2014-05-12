require 'eventmachine'
require 'em-http-request'

class Downloadr
  def initialize(filename, url)
    @length    = 0
    @progress  = 0
    @completed = false
    @filename  = filename
    @url       = url
  end

  def progress
    @progress.to_f / @length.to_f * 100
  end

  def completed?
    @completed
  end

  def update_progress(add)
    @progress += add
  end

  def run
    Thread.new do
      File.open(@filename, "w") do |file|
        EventMachine.run do
          http = EventMachine::HttpRequest.new(@url).get

          http.headers{ |hash| @length = hash["CONTENT_LENGTH"].to_i }

          http.stream{ |chunk| update_progress(chunk.length); file.write(chunk) }

          http.callback{ @completed = true }
        end
      end
    end
  end
end
