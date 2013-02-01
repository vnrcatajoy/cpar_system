class FixColumnName < ActiveRecord::Migration
  def change
  	change_table :issues do |t|
  	  t.rename :originator_id, :user_id
  	  t.rename :department_in_charge_id, :department_id

  	end
    
    change_table :departments do |t|
      t.rename :owner_id, :user_id
    end
    
  end
end
