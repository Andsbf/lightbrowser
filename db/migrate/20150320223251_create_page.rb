class CreatePage < ActiveRecord::Migration

  def change
    create_table :pages do |t|
      t.references :user
      t.string :address
      t.timestamps
    end 
  end
end
