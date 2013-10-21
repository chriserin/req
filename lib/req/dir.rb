require 'fileutils'
require 'pathname'

module Req
  class Dir
    class << self
      def home
        ".req"
      end

      def make_home_dir
        FileUtils.mkdir(home) unless File.exists?(home)
      end

      def create(url="/")
        url = "root" if url == "/"
        new(File.join(url, unique_dir_name))
      end

      def latest
        path = ::Dir["{.req/**/req-*,.req/empty_page}"].sort_by {|dir| File.stat(dir).ctime }.last
        new(path) if path
      end

      private
      def unique_dir_name
        "req-#{rand(36**8).to_s(36)}"
      end
    end

    attr_reader :path
    def initialize(path="root")
      @path = path
      @path = File.join(Dir.home, path) unless path.include? Dir.home
      create_dir(@path)
    end

    def output_path
      File.join(@path, "output.html")
    end

    def write(content)
      File.open(File.join(@path, "output.html"), "w") do
        |file| file.write(content)
      end
    end

    def write_asset(url, content)
      File.open(asset_path(url), "w") do |file|
        file.write(content)
      end
    end

    def remove
      FileUtils.rmdir(@path)
    end

    private
    def create_dir(dir)
      FileUtils.mkdir_p(dir)
    end

    def asset_path(url)
      path = File.join(@path, Pathname.new(url).dirname)
      create_dir(path)
      File.join(path, Pathname.new(url).basename)
    end
  end
end
