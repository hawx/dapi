module Dapi
  def self.load(path)
    ::Dapi::Dapi.new.tap {|e| e.instance_eval File.read(path) }
  end

  class Dapi
    attr_reader :endpoints

    def initialize
      @endpoints = []
    end

    def title(str = nil)
      str ? @title = str : @title
    end

    def description(str = nil)
      str ? @description = str : @description
    end

    def endpoint(url, &block)
      e = Endpoint.new(url)
      e.instance_eval(&block)
      @endpoints << e
    end

    def helper(klass, &block)
      klass.class_eval &block
    end
  end

  class Endpoint
    attr_reader :url, :methods

    def initialize(url)
      @url = url
      @methods = []
    end

    def method(verb, &block)
      m = HttpMethod.new(verb.upcase)
      m.instance_eval &block
      @methods << m
    end
  end

  class HttpMethod
    attr_reader :verb, :responses

    def initialize(verb)
      @verb = verb
      @responses = []
    end

    def description(desc = nil)
      desc ? @description = desc : @description
    end

    def request(&block)
      return @request unless block_given?

      @request = Request.new
      @request.instance_eval &block
    end

    def response(code, &block)
      r = Response.new(code)
      r.instance_eval &block
      @responses << r
    end
  end

  Parameter = Struct.new(:name, :description, :opts)
  Header = Struct.new(:name, :description, :opts)

  class Request
    attr_reader :parameters, :headers

    def initialize
      @parameters = []
      @headers = []
    end

    def body(str = nil)
      str ? @body = str : @body
    end

    def example(str = nil)
      str ? @example = str : @example
    end

    def parameter(name, description, opts={})
      @parameters << Parameter.new(name, description, opts)
    end

    def header(name, description, opts={})
      @headers << Header.new(name, description, opts)
    end
  end

  class Response
    attr_reader :code, :headers

    def initialize(code)
      @code = code
      @headers = []
    end

    def body(str = nil)
      str ? @body = str : @body
    end

    def reason(text = nil)
      text ? @reason = text : @reason
    end

    def header(name, description, opts={})
      @headers << Header.new(name, description, opts)
    end
  end
end
