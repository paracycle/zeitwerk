# frozen_string_literal: true

require "test_helper"

class TestSyntaxTreeInflector < LoaderTest
  def with_setup
    files = [
      ["lib/my_gem.rb", <<-EOS],
        loader = Zeitwerk::Loader.for_gem
        loader.inflector = Zeitwerk::SyntaxTreeInflector.new
        loader.enable_reloading
        loader.setup

        module MyGem
        end
      EOS
      ["lib/my_gem/foo.rb", "MyGem::Foo = true; MyGem::Bar = true"],
      ["lib/my_gem/version.rb", "MyGem::VERSION = '1.0.0'"],
      ["lib/my_gem/ns/version.rb", "MyGem::Ns::Version = true"]
    ]
    with_files(files) do
      with_load_path("lib") do
        assert require("my_gem")
        yield
      end
    end
  end

  test "the constant for my_gem/version.rb is inflected as VERSION" do
    with_setup { assert_equal "1.0.0", MyGem::VERSION }
  end

  test "other possible version.rb are inflected normally" do
    with_setup { assert MyGem::Ns::Version }
  end

  test "works as expected for other files" do
    with_setup { assert MyGem::Foo; assert MyGem::Bar }
  end
end
