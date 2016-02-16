class AddBaiDuUrlToRecommends < ActiveRecord::Migration
  def change
    add_column :recommends, :baidu_url, :string
  end
end
