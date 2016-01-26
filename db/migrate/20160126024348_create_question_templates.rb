class CreateQuestionTemplates < ActiveRecord::Migration
  def change
    create_table :question_templates do |t|
      t.string :text
      t.boolean :help_text
      t.references :template, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
