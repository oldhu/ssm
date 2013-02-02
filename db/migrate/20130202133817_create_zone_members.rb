class CreateZoneMembers < ActiveRecord::Migration
  def change
    create_table :zone_members do |t|
      t.integer :zone_id
      t.string :member
      t.timestamps
    end
  end
end
