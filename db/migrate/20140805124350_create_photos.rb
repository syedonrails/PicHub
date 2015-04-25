class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
    	t.references :album
    	t.string :short_desc
      t.timestamps
    end
  end
end
