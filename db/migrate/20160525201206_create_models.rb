class CreateModels < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.integer :sequence, null: false
      t.string :type
      t.text :data

      t.timestamps
    end

    create_table :numeric_entities do |t|
      t.integer :integer

      t.timestamps
    end

    create_table :textual_entities do |t|
      t.string :text

      t.timestamps
    end
  end
end
