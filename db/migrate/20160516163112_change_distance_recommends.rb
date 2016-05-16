class ChangeDistanceRecommends < ActiveRecord::Migration
  def change
  	change_column :recommends, :distance, :float
  end
end
