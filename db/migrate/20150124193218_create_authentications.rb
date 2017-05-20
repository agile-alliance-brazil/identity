# Migration to create authentications
class CreateAuthentications < ActiveRecord::Migration[4.2]
  def change
    create_table :authentications do |t|
      t.string :user_id
      t.string :provider
      t.string :uid
    end
  end
end
