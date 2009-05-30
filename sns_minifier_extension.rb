class SnsMinifierExtension < Radiant::Extension
  version "0.1.1"
  extension_name "Styles 'n Scripts Minifier"
  description "Allows you to minify (compress) the output of your stylesheets and javascripts via the Styles 'n Scripts Extension."
  url ""
  
  def activate
    raise "The SnS Minifier extension requires the Styles 'n Scripts extension be loaded first!" unless defined?(TextAsset)
    admin.text_assets.edit.add :content_bottom, "minify", :after => 'edit_filter'
    TextAsset.send :include, TextAssetMixins
  end
  
  def deactivate
  end
  
end