require 'rubygems'
require 'test/unit'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

#[File.join(File.dirname(__FILE__), '..', 'lib', 'munger'),
# File.dirname(__FILE__)].each do |path|
#  path = File.expand_path(path)
#  unless $LOAD_PATH.include?(path)
#    # puts "test/helper: $LOAD_PATH << #{path}"
#    $LOAD_PATH.unshift(path)
#  end
#end

require 'munger'

class Test::Unit::TestCase
end

def my_assert_equal(expected, was)
  assert expected == was, "--- Expected:\n#{expected}\n--- Was:\n#{was}"
end
