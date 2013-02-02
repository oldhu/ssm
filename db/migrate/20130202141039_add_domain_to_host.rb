class AddDomainToHost < ActiveRecord::Migration
  def change
    add_column :hosts, :domain, :string
  end
end
