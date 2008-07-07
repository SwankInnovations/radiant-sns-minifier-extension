class AddMinifyColumn < ActiveRecord::Migration
  def self.up
    add_column :text_assets, :minify, :boolean
  end
  
  def self.down
    remove_column :text_assets, :minify
  end
end