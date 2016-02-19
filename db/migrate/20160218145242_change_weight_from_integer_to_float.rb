class ChangeWeightFromIntegerToFloat < ActiveRecord::Migration
  def change
    change_column :shipment_weight_relations, :min_weight, :float
    change_column :shipment_weight_relations, :max_weight, :float
  end
end
