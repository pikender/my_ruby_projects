class CreateMoveIns < ActiveRecord::Migration
  def change
    create_table :move_ins do |t|
      t.string :name
      t.integer :office_id

      t.timestamps
    end
  end
end
