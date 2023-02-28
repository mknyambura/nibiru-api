class AddColorToProject < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :color, :string
  end
end
