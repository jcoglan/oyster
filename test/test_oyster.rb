require 'test/unit'
require 'oyster'

class OysterTest < Test::Unit::TestCase
  
  def setup
    @spec = Oyster.spec do
      flag  :verbose,   :default => true
    end
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
  
end

