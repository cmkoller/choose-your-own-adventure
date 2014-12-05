class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer :story_id
      t.integer :page_num
      t.string :page_header
      t.text :page_body
      t.string :action1
      t.string :dest1
      t.string :action2
      t.string :dest2
      t.string :action3
      t.string :dest3
      t.string :action4
      t.string :dest4
    end
  end
end
