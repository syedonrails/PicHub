class AddPositionToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :position, :integer, :after => :short_desc
  end
end
