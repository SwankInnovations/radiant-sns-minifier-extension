# Encapsulates the Dean Edwards Packer JS minifier
#
# Be warned, Packer expects specific things within your Javascript.  It's a 
# *great* minifier but know what you're doing.
class PackrMinifier < Minifier
  # See vendor/plugins/packr/lib/packer.rb for more info on how this minifier
  # works.  Valid options include:
  #   :shrink_vars
  #   :base62
  def self.minify(text, options={})
    Packr.new.pack(text, options)
  end
end