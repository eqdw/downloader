require 'typhoeus'

class Downloader
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
    file = File.open(@filename, "w")

    request = Typhoeus::Request.new(@url)

    request.on_headers do |response|
      binding.pry
      @length = response.headers_hash["Content-Length"].to_i
    end

    request.on_body do |chunk|
      update_progress(chunk.length)
      file.write(chunk)
    end

    request.on_complete do |response|
      @completed = true
      file.close
    end

    Thread.new{ request.run }
  end
end
