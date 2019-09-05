# ==UTF8_sanitizer originally by whitequark on github
#  https://github.com/whitequark/rack-utf8_sanitizer
#  edited by cpeppis july 2014
#  also based on utf8-cleaner by singlebrook on github
#  https://github.com/singlebrook/utf8-cleaner
#  also uses some code/ideas from http://stackoverflow.com/a/8873922
# Middleware to sanitize input to the server in order 
# to avoid problems with invalid encoding from users.
# This has been a big problem with a number of spiders
# that appear to ignore the robots.txt (mainly one from a 
# Chinese search engine called Easou). They make random
# requests to the server with POST data full of
# random crap that used to cause several 500 error
# warning emails a day.
#
# encoding: UTF-8

require 'uri'
require 'stringio'

class UTF8Sanitizer
  StringIO = ::StringIO

  def initialize(app)
    @app = app
  end

  # Sanitizes the env before calling our app
  def call(env)
    myEnv = sanitize(env)
    @app.call(myEnv)
  end

  # http://rack.rubyforge.org/doc/SPEC.html
  URI_FIELDS  = %w(
      SCRIPT_NAME
      REQUEST_PATH REQUEST_URI PATH_INFO
      QUERY_STRING
      HTTP_REFERER
      rack.request.form_vars
  ) #### added this last line to fix a thingy with POST data hopefully ####

  SANITIZABLE_CONTENT_TYPES = %w(
      text/plain
      application/x-www-form-urlencoded
  )


  private

  # Method that calls helper methods to sanitize each element of the env
  # that needs to be looked at
  def sanitize(env)
    # request_method = env['REQUEST_METHOD']
    # if request_method == POST || request_method == PUT
    sanitize_rack_input(env)
    # end ## I think we may be having a problem with spiders 
          ## where they will give us rack input somehow even though
          ## the request method is a GET
    env.each do |key, value|
      if URI_FIELDS.include?(key) || key.start_with?("HTTP_")
        env[key] = fix_encoding(value)
      end
    end
  end

  # Method that sanitizes the rack_input io stream by reading it,
  # fixing its encoding, and then remaking it.
  def sanitize_rack_input(env)
    # https://github.com/rack/rack/blob/master/lib/rack/request.rb#L42
    # Logic borrowed from Rack::Request#media_type,#media_type_params,#content_charset
    # Ignoring charset in content type.
    content_type   = env['CONTENT_TYPE']
    content_type &&= content_type.split(/\s*[;,]\s*/, 2).first
    content_type &&= content_type.downcase
    return unless SANITIZABLE_CONTENT_TYPES.any? {|type| content_type == type }
    if env['rack.input']
      input = env['rack.input'].read
      sanitized_input = fix_encoding(input)
      env['rack.input'] = StringIO.new(sanitized_input) if sanitized_input
      env['rack.input'].rewind
    end
  end


  # Encodes a value into UTF-16 and then reencodes it back to UTF8
  # this should hopefully force ruby to actually have to change the encoding
  # and not skip over things that it thinks are already encoded in UTF8
  # Idea from http://stackoverflow.com/a/8873922
  def fix_encoding(value)
    cleaned_value = value.encode('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
    cleaned_value.encode!('UTF-8', 'UTF-16', :invalid=> :replace, :replace => '')
    begin
      URI.decode_www_form_component(cleaned_value)
    rescue
      Rails.logger.warn "Unable to decode #{cleaned_value}"
      cleaned_value = "ARGUMENT ERROR"
    end
    cleaned_value
  end
end
