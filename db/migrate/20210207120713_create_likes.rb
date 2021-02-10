class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.references :user, type: :bigint, foreign_key: true
      t.references :post, type: :bigint, foreign_key: true

      t.timestamps
    end
  end
end
