class CreateOptionTemplates < ActiveRecord::Migration
  def change
    create_table :option_templates do |t|
      t.references :response_template, index: true, foreign_key: true
      t.string :value

      t.timestamps null: false
    end
  end
end
