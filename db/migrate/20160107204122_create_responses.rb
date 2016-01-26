class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.boolean :boolean_value
      t.integer :integer_value
      t.string :string_value
      t.text :text_value
      t.references :question, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :response_type

      t.timestamps null: false
    end
  end
end
