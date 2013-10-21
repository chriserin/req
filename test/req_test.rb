gem 'minitest'
require 'minitest/autorun'
require 'req'
require 'fileutils'
require 'ostruct'

class ReqTest < Minitest::Test
  def test_latest_with_no_dir
    out, err = capture_io do
      Req::CLI.new.send(:latest)
    end
    assert_equal "no req directories", out.strip
  end

  def test_latest_with_dir
    dirs = Req::Dir.create("/").path
    out, err = capture_io do
      Req::CLI.new.send(:latest)
    end
    assert_equal dirs, out.strip
  end

  def test_get
    out = ''
    ::Dir.stub :pwd, "./test/support" do
      out, err = capture_io do
        Req::CLI.new.send(:get, "/")
      end
    end
    assert_equal "test_output", out.strip
  end

  def test_repl
    out = ''
    Req::Repl.stub :prompt, OpenStruct.new(:gets => "exit") do
      out, err = capture_io do
        Req::CLI.new.send(:repl)
      end
    end
    assert_includes "> ", out
  end

  def test_exec
    out, err = capture_io do
      Req::CLI.new.send(:exec, "null")
    end
    assert_equal "null", out.strip
  end

  def test_css_no_req_dir
    out, err = capture_io do
      Req::CLI.new.send(:css, "div")
    end
    assert_equal "no req dir", out.strip
  end

  def test_css
    mk_test_output
    out, err = capture_io do
      Req::CLI.new.send(:css, "div")
    end
    assert_equal "<div></div>", out.strip
  end

  def mk_test_output
    Req::Dir.create.write("<html><body><div></div></body></html>")
  end

  def setup
    FileUtils.rm_rf(".req")
  end

  def teardown
    FileUtils.rm_rf(".req")
  end
end

class Rails
  class << self
    def application
      "stub"
    end
  end
end

module ActionDispatch
  module Integration
    class Session
      def initialize(app_stub)
      end

      def get(path)
      end

      def request
        OpenStruct.new(:path => "xxx")
      end

      def response
        OpenStruct.new(:body => "test_output", :status => 200)
      end
    end
  end
end
