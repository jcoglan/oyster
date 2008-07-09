require 'test/unit'
require 'oyster'

class OysterTest < Test::Unit::TestCase
  
  def setup
    @spec = Oyster.spec do
      name      'oyster'
      synopsis <<-EOS
      oyster [OPTIONS] filename
      oyster [-e PATTERN] file1 [, file2 [, file3 [, ...]]]
      EOS
      description <<-EOS
      Oyster is a Ruby command-line option parser that doesn't hate you. It lets
      you specify options using a simple DSL and parses user input into a hash to
      match the options your program accepts.
      
        class Foo < Option
          def consume(list); end
        end
      
      Nothing to see here.
      EOS
      
      flag    :verbose, :default => true, :desc => 'Print verbose output'
      
      string  :user
      
      string  :binary,  :default => 'ruby', :desc => <<-EOS
      Which binary to use. You can change the executable used to format the output
      of this command, setting it to your scripting language of choice. This is just
      a lot of text to make sure help formatting works.
      EOS
      
      array   :files, :desc => 'The files you want to process'
      
      notes <<-EOS
      This program is free software, distributed under the MIT license.
      EOS
      
      author 'James Coglan <jcoglan@googlemail.com>'
    end
  end
  
  def test_help
    @spec.parse %w(--help)
  rescue Oyster::HelpRendered
  end
  
  def test_dash_length
    opts = @spec.parse %w(-user me)
    assert_equal nil, opts[:user]
    opts = @spec.parse %w(--u me)
    assert_equal nil, opts[:user]
  end
  
  def test_flags
    opts = @spec.parse %w(myfile.txt --verbose)
    assert_equal true, opts[:verbose]
    assert_equal 'myfile.txt', opts[:unclaimed].first
    opts = @spec.parse %w(myfile.text -v)
    assert_equal true, opts[:verbose]
    opts = @spec.parse %w(--no-verbose)
    assert_equal false, opts[:verbose]
    
    assert_equal false, opts[:help]
  end
  
  def test_strings
    opts = @spec.parse %w(-v --user jcoglan something)
    assert_equal 'jcoglan', opts[:user]
    assert_equal 'something', opts[:unclaimed].first
    opts = @spec.parse %w(-v)
    assert_equal nil, opts[:user]
    opts = @spec.parse ['-u', "My name is"]
    assert_equal 'My name is', opts[:user]
    
    opts = @spec.parse %w(-b)
    assert_equal 'ruby', opts[:binary]
    opts = @spec.parse %w(--binary some_other_prog)
    assert_equal 'some_other_prog', opts[:binary]
  end
  
  def test_string_with_flag
    opts = @spec.parse %w(the first --user is -v)
    assert_equal 'the, first', opts[:unclaimed].join(', ')
    assert_equal 'is', opts[:user]
    assert_equal true, opts[:verbose]
  end
  
  def test_array
    opts = @spec.parse %w(--files foo bar baz -u jcoglan)
    assert_equal 'foo, bar, baz', opts[:files].join(', ')
    assert_equal 'jcoglan', opts[:user]
    opts = @spec.parse %w(--files foo bar baz)
    assert_equal 'foo, bar, baz', opts[:files].join(', ')
  end
  
end

