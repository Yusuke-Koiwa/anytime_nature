class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :text, null: false
      t.references :user, null: false, foreign_key: true
      t.references :picture, null: false, foreign_key: true
      t.timestamps
    end
  end
end