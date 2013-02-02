class ChangeSpeedToString < ActiveRecord::Migration
  def change
    change_column :brocade_ports, :speed, :string
  end
end
