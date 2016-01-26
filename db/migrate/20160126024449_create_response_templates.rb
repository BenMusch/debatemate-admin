class CreateResponseTemplates < ActiveRecord::Migration
  def change
    create_table :response_templates do |t|
      t.string :type
      t.references :question_template, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
