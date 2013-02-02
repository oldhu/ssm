class CreateHosts < ActiveRecord::Migration
  def change
    create_table :hosts do |t|
      t.string :name
      t.string :type
      t.string :host
      t.string :user
      t.string :pass
      t.timestamps
    end
  end
end
