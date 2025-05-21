class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.bigint :shopify_id
      t.string :title
      t.text :description
      t.decimal :price
      t.string :status
      t.string :sku

      t.timestamps
    end
  end
end
