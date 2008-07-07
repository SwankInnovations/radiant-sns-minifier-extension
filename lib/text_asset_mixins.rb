module TextAssetMixins

  # Change these settings to configure which minifiers will be used.
  # Built-in CSS Minifiers:
  #   * CssminMinifier
  #   * RainpressMinifier
  # Built-in JS Minifiers:
  #   * JsminMinifier
  #   * PackrMinifier
  # See each of these models and their related plugins for possible options
  @@settings = { :css_minifier => CssminMinifier,
                 :css_minify_opts => {:enhanced => true},
                 :js_minifier => JsminMinifier,
                 :js_minify_opts => {} }


  def self.included(base)
    base.class_eval do
      alias_method_chain :render, :minification
    end
  end


  def minifiable?
    if self.class == Stylesheet
      !@@settings[:css_minifier].blank?
    elsif self.class == Javascript
      !@@settings[:js_minifier].blank?
    end
  end


  private
  
    def render_with_minification
      text = render_without_minification
      if minifiable? && minify? then
        text = minify_css(text) if self.class == Stylesheet
        text = minify_js(text) if self.class == Javascript
      end
      text
    end


    def minify_css(text)
      @@settings[:css_minifier].minify(text,@@settings[:css_minify_opts])
    end
    
    
    def minify_js(text)
      @@settings[:js_minifier].minify(text,@@settings[:js_minify_opts])
    end
end