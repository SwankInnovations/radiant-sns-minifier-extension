# encapsulates the Dean Edwards Packer JS minifier
class JsminMinifier < Minifier
  # See vendor/plugins/jsmin/lib/jsmin.rb for more info on how this minifier
  # works.  Valid options include:
  #   ???  None, I think
  def self.minify(text, options={})
    JSMin.minify(text)
  end
end