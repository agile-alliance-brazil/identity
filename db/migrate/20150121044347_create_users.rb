class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string      :username, null: false
      t.string      :first_name, null: false
      t.string      :last_name, null: false
      t.string      :phone
      t.string      :state
      t.string      :city
      t.string      :organization
      t.string      :website_url
      t.text        :bio
      t.string      :country
      t.string      :twitter_username
      t.string      :default_locale, null: false, default: "pt"

      t.timestamps

      # Devise

      ## Database authenticatable
      t.string :email, null: false
      t.string :encrypted_password, null: false

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      ## Token authenticatable
      t.string :authentication_token
    end

    add_index :users, :username
    add_index :users, :confirmation_token
    add_index :users, :email
    add_index :users, :authentication_token
    add_index :users, :reset_password_token
  end
end
