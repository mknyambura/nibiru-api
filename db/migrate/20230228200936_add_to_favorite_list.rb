class AddToFavoriteList < ActiveRecord::Migration[6.1]
  def change
    def change
      add_column :projects, :favorite, :boolean
    end
  end
end
