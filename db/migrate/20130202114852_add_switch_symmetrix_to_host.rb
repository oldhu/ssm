class AddSwitchSymmetrixToHost < ActiveRecord::Migration
  def change
    add_column :hosts, :sid, :string
    add_column :hosts, :is_principal, :boolean
  end
end
