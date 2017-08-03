class CreateSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :songs do |t|
      t.string :name
      t.integer :duration
      t.string :genre
      t.boolean :featured
      t.references :artist, foreign_key: true
      t.references :album, foreign_key: true
      t.references :playlist, foreign_key: true

      t.timestamps
    end
  end
end
