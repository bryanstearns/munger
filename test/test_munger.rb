require File.dirname(__FILE__) + '/helper'

class TestMunger < Test::Unit::TestCase
  def setup
    @verbose = nil
    @text = """Existing line number one
Existing line number two
Existing line number three
"""
  end

  def test_before
    @text = Munger::munge(:mode => :before,
                          :pattern => "line number one",
                          :tag => "# BeforeOneTest", :input => @text,
                          :content => "This goes before line one",
                          :verbose => @verbose)
    my_assert_equal \
      """# BeforeOneTest (munge start)
This goes before line one
# BeforeOneTest (munge end)
Existing line number one
Existing line number two
Existing line number three
""", @text

    @text = Munger::munge(:mode => :before,
                          :pattern => "line number two",
                          :tag => "# BeforeTwoTest", :input => @text,
                          :content => "This goes before line two",
                          :verbose => @verbose)
    my_assert_equal \
      """# BeforeOneTest (munge start)
This goes before line one
# BeforeOneTest (munge end)
Existing line number one
# BeforeTwoTest (munge start)
This goes before line two
# BeforeTwoTest (munge end)
Existing line number two
Existing line number three
""", @text
  end

  def test_after
    @text = Munger::munge(:mode => :after,
                          :pattern => "line number three",
                          :tag => "# AfterThreeTest", :input => @text,
                          :content => "This goes after line three",
                          :verbose => @verbose)
    my_assert_equal \
      """Existing line number one
Existing line number two
Existing line number three
# AfterThreeTest (munge start)
This goes after line three
# AfterThreeTest (munge end)
""", @text

    @text = Munger::munge(:mode => :after,
                          :pattern => "line number three",
                          :tag => "# AfterThreeTest", :input => @text,
                          :content => "New stuff for after line three",
                          :verbose => @verbose)
    my_assert_equal \
      """Existing line number one
Existing line number two
Existing line number three
# AfterThreeTest (munge start)
New stuff for after line three
# AfterThreeTest (munge end)
""", @text
  end

  def test_replace
    @text = Munger::munge(:mode => :replace, :tag => "# ReplaceTest",
                          :pattern => "line number two",
                          :input => @text,
                          :content => "This is some stuff to replace with",
                          :verbose => @verbose)
    my_assert_equal \
      """Existing line number one
# ReplaceTest (munge start)
This is some stuff to replace with
# ReplaceTest (munge end)
Existing line number three
""", @text
  end

  def test_replace_or_append_replacing
    @text = Munger::munge(:mode => :replace_or_append,
                          :tag => "# ReplaceOrAppendTest",
                          :pattern => "line number two",
                          :input => @text,
                          :content => "This is some stuff to replace with",
                          :verbose => @verbose)
    my_assert_equal \
      """Existing line number one
# ReplaceOrAppendTest (munge start)
This is some stuff to replace with
# ReplaceOrAppendTest (munge end)
Existing line number three
""", @text
  end

  def test_replace_or_append_appending
    @text = Munger::munge(:mode => :replace_or_append,
                          :tag => "# ReplaceOrAppendTest",
                          :pattern => "does not exist",
                          :input => @text,
                          :content => "This is some stuff to replace with",
                          :verbose => @verbose)
    my_assert_equal \
      """Existing line number one
Existing line number two
Existing line number three
# ReplaceOrAppendTest (munge start)
This is some stuff to replace with
# ReplaceOrAppendTest (munge end)
""", @text
  end

  def test_append
    @text = Munger::munge(:mode => :append, :tag => "# AppendTest",
                          :input => @text,
                          :content => "This is some stuff to append",
                          :verbose => @verbose)
    my_assert_equal \
      """Existing line number one
Existing line number two
Existing line number three
# AppendTest (munge start)
This is some stuff to append
# AppendTest (munge end)
""", @text

    @text = Munger::munge(:mode => :append, :tag => "# AppendTest",
                          :input => @text,
                          :content => "New stuff to append",
                          :verbose => @verbose)
    my_assert_equal \
      """Existing line number one
Existing line number two
Existing line number three
# AppendTest (munge start)
New stuff to append
# AppendTest (munge end)
""", @text
  end
end
