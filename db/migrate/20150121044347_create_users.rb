class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string      :username
      t.string      :email
      t.string      :encrypted_password
      t.string      :password_salt
      t.string      :first_name
      t.string      :last_name
      t.string      :phone
      t.string      :state
      t.string      :city
      t.string      :organization
      t.string      :website_url
      t.text        :bio
      t.string      :country
      t.datetime    :current_sign_in_at
      t.datetime    :last_sign_in_at
      t.string      :current_sign_in_ip
      t.string      :last_sign_in_ip
      t.string      :default_locale, default: "pt"
      t.string      :reset_password_token
      t.string      :authentication_token
      t.integer     :sign_in_count
      t.datetime    :reset_password_sent_at
      t.string      :twitter_username
      t.timestamps
    end
  end
end
