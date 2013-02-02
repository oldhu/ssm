class CreateBrocadePorts < ActiveRecord::Migration
  def change
    create_table :brocade_ports do |t|
      t.integer :host_id
      t.integer :index
      t.integer :slot
      t.integer :port
      t.integer :speed
      t.string :state
      t.string :type
      t.string :wwn
      t.timestamps
    end
  end
end
