# encapsulates the Rainpress CSS minifier
class RainpressMinifier < Minifier
  # See vendor/plugins/rainpress/lib/packer.rb for more info on how this minifier
  # works.  Valid options include:
  #   :preserveComments
  #   :preserveNewlines
  #   :preserveSpaces
  #   :preserveColors
  #   :skipMisc
  def self.minify(text, options={})
    Rainpress::Packer.new.compress(text, options)
  end
end