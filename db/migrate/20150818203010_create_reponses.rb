class CreateReponses < ActiveRecord::Migration
  def change
    create_table :reponses do |t|
      t.text :text
      t.references :user, index: true, foreign_key: true
      t.references :respondable, polymorhpic: true, index: true
    end

    remove_column :lessons, :goals, :text
  end
end
