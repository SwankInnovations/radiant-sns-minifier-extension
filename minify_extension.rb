# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class MinifyExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/minify"
  
  # define_routes do |map|
  #   map.connect 'admin/minify/:action', :controller => 'admin/minify'
  # end
  
  def activate
    # admin.tabs.add "Minify", "/admin/minify", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    # admin.tabs.remove "Minify"
  end
  
end