# encapsulates the CSSMin CSS minifier
class CssminMinifier < Minifier

  # See vendor/plugins/cssmin/lib/cssmin.rb for more info on how this minifier
  # works.  Valid options include:
  #   :enhanced (adds my own improvements to the mix)
  def self.minify(text, options={})
    text = CSSMin.minify(text)

    if options[:enhanced]
      # Replace 6.0 with 6, but only when preceded by : or a space.
      text.gsub!(/(:|\s)(\d+)\.0+(?=[^\d])/, '\1\2')
      
      # Replace : 2em 2em 2em 2em; with :2em;
      text.gsub!(/(?!:)((?:\d+|\d+\.[1-9]+|\.[1-9]+)(?:%|em|ex|px|in|cm|mm|pt|pc))\s+\1\s+\1\s+\1(?=;|\})/, '\1')
  
      # Replace ': 2em 3px 2em 3px;' with ':2em 3px;'
      text.gsub!(/(?!:)((?:\d+|\d+\.[1-9]+|\.[1-9]+)+(?:%|em|ex|px|in|cm|mm|pt|pc)\s+(?:\d+|\d+\.[1-9]+|\.[1-9]+)+(?:%|em|ex|px|in|cm|mm|pt|pc))\s+\1(?=;|\})/, '\1')
    end

    text
  end

end