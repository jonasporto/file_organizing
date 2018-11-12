class CreateFileTags < ActiveRecord::Migration[5.1]
  def change
    create_table :file_tags, primary_key: :uuid, id: :text do |t|
      t.text :name
      t.text :tags

      t.timestamps
    end
  end
end
