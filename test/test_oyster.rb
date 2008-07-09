require 'test/unit'
require 'oyster'

class OysterTest < Test::Unit::TestCase
  
  def setup
    @spec = Oyster.spec do
      flag    :verbose, 'Print verbose output',   :default => true
      string  :user
      string  :binary,  'Which binary to use',    :default => 'ruby'
      array   :files,   'The files you want to process'
    end
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
  end
  
end

