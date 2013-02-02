class CreatePorts < ActiveRecord::Migration
  def change
    create_table :ports do |t|
      t.string :dev
      t.string :wwn
      t.integer :speed
      t.integer :host_id
      t.timestamps
    end
  end
end
