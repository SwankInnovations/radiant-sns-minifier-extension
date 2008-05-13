##############################
# Test for Rainpress::Packer #
##############################
#
#--
# Copyright (c) 2007-2008 Uwe L. Korn
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#++
#
# Author:: Uwe L. Korn <uwelk@xhochy.org>
# Copyright:: Copyright (c) 2007-2008 Uwe L. Korn
# License:: MIT-style License (see Rainpress)require 'test/unit'

require 'test/unit'
require File.join(File.dirname(__FILE__), 'packer.rb')

module Rainpress
  # This class keeps all Tests for the class Rainpress::Packer
  #
  # Author:: Uwe L. Korn <uwelk@xhochy.org>
  class TestPacker < Test::Unit::TestCase
		
	# Create an instace of Rainpress::Packer for use in the tests
	def setup
	  @packer = Rainpress::Packer.new
	end
		
	# Test Rainpress::Packer.remove_comments
	def test_remove_comments
      options = {
        :preserveComments => false,
        :preserveNewlines => true,
        :preserveSpaces => true,
        :preserveColors => true,
        :skipMisc => true
      }  
	  
	  # plain comment -> ''
	  input = '/* sss */';
	  assert_equal('', @packer.compress(input, options))
	  
	  # no comment -> no change
	  input = 'sss';
	  assert_equal('sss', @packer.compress(input, options))
	  
	  # comment floating in text			 
	  input = 's/*ss*/ss';
	  assert_equal('sss', @packer.compress(input, options))			
      
      # empty string
      input = ''
      assert_equal('', @packer.compress(input, options))
	end
		
    # Test Rainpress::Packer.remove_newlines
    def test_remove_newlines
      options = {
        :preserveComments => true,
        :preserveNewlines => false,
        :preserveSpaces => true,
        :preserveColors => true,
        :skipMisc => true
      }  
    
      # plain unix-newline
      input = "\n"
      assert_equal('', @packer.compress(input, options))
    
      # plain windows newline
      input = "\r\n"
      assert_equal('', @packer.compress(input, options))
    
      # no newline
      input = "rn"
      assert_equal('rn', @packer.compress(input, options))
    
      # newlines floatin in text
      input = "sss\n||\r\nsss"
      assert_equal('sss||sss', @packer.compress(input, options))
    
      # empty string
      input = ''
      assert_equal('', @packer.compress(input, options))
	end
    
    # Test Rainpress::Packer.remove_spaces
    def test_remove_spaces
      options = {
        :preserveComments => true,
        :preserveNewlines => true,
        :preserveSpaces => false,
        :preserveColors => true,
        :skipMisc => true
      }  
      
      # (a) Turn mutiple Spaces into a single, but not less
      input = '  ' # 2 spaces
      assert_equal(' ', @packer.compress(input, options))
      input = '   ' # 3 spaces
      assert_equal(' ', @packer.compress(input, options))
      
      # (b) remove spaces around ;:{},
      input = ' ; '
      assert_equal(';', @packer.compress(input, options))
      input = ' : '
      assert_equal(':', @packer.compress(input, options))
      input = ' { '
      assert_equal('{', @packer.compress(input, options))
      input = ' } '
      assert_equal('}', @packer.compress(input, options))
      input = ' , '
      assert_equal(',', @packer.compress(input, options))
      # (c) remove tabs
      input = "\t"
      assert_equal('', @packer.compress(input, options))
    end
    
    # Test Rainpress::Packer.shorten_colors
    def test_shorten_colors
      options = {
        :preserveComments => true,
        :preserveNewlines => true,
        :preserveSpaces => true,
        :preserveColors => false,
        :skipMisc => true
      } 
      # rgb(50,101,152) to #326598
      input = 'color:rgb(12,101,152)'
      assert_equal('color:#0c6598', @packer.compress(input, options))
      
      # #AABBCC to #ABC
      input = 'color:#AAbBCC'
      assert_equal('color:#abc', @packer.compress(input, options))
      # Keep chroma(color="#FFFFFF"); ... due to IE
      input = 'chroma(color="#FFFFFF");'
      assert_equal('chroma(color="#FFFFFF");', @packer.compress(input, options))
      
      # shorten several names to numbers
      input = 'color:white;'
      assert_equal('color:#fff;', @packer.compress(input, options))
      input = 'color: white}'
      assert_equal('color:#fff}', @packer.compress(input, options))
      
      # shotern several numbers to names
      input = 'color:#ff0000;'
      assert_equal('color:red;', @packer.compress(input, options))
      input = 'color:#F00;'
      assert_equal('color:red;', @packer.compress(input, options))
    end
  
    # Test Rainpress::Packer.do_misc
    def test_do_misc
      options = {
        :preserveComments => true,
        :preserveNewlines => true,
        :preserveSpaces => true,
        :preserveColors => true,
        :skipMisc => false
      }  
      # Replace 0(pt,px,em,%) with 0
      input = ' 0px'
      assert_equal(' 0', @packer.compress(input, options))
      input = ' 0em'
      assert_equal(' 0', @packer.compress(input, options))
      input = ' 0pt'
      assert_equal(' 0', @packer.compress(input, options))
      input = ' 0%'
      assert_equal(' 0', @packer.compress(input, options))
      input = ' 0in'
      assert_equal(' 0', @packer.compress(input, options))
      input = ' 0cm '
      assert_equal(' 0 ', @packer.compress(input, options))
      input = ':0mm'
      assert_equal(':0', @packer.compress(input, options))
      input = ' 0pc'
      assert_equal(' 0', @packer.compress(input, options))
      input = '  0ex'
      assert_equal('  0', @packer.compress(input, options))
      input = ' 10ex'
      assert_equal(' 10ex', @packer.compress(input, options))
      
      # Replace 0 0 0 0; with 0.
      input = ':0 0;'
      assert_equal(':0;', @packer.compress(input, options))
      input = ':0 0 0;'
      assert_equal(':0;', @packer.compress(input, options))
      input = ':0 0 0 0;'
      assert_equal(':0;', @packer.compress(input, options))
      input = ':0 0 0 0}'
      assert_equal(':0}', @packer.compress(input, options))
      # Keep 'background-position:0 0;' !!
      input = 'background-position:0 0;'
      assert_equal('background-position:0 0;', @packer.compress(input, options))
      
      # Replace 0.6 to .6, but only when preceded by : or a white-space
      input = ' 0.6'
      assert_equal(' .6', @packer.compress(input, options))
      input = ':0.06'
      assert_equal(':.06', @packer.compress(input, options))
      input = '10.6'
      assert_equal('10.6', @packer.compress(input, options))
      
      # Replace ;;;; with ;
      input = 'ss;;;ss'
      assert_equal('ss;ss', @packer.compress(input, options))
      
      # Replace ;} with }
      input = 'ss;sss;}ss'
      assert_equal('ss;sss}ss', @packer.compress(input, options))
      
      # Replace background-color: with background:
      input = 'background-color:'
      assert_equal('background:', @packer.compress(input, options))
      
      # Replace font-weight:normal; with 400, bold with 700
      input = 'font-weight: normal;'
      assert_equal('font-weight:400;', @packer.compress(input, options))
      input = 'font: normal;'
      assert_equal('font: 400;', @packer.compress(input, options))
      input = 'font: bold 1px;'
      assert_equal('font: 700 1px;', @packer.compress(input, options))
    end
		
  end
end	
