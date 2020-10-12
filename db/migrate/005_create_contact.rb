class CreateContact < ActiveRecord::Migration[5.0]

    def change
        create_table :contacts do |f|
            f.integer :account_id
            f.integer :contact_id
            f.string :name
            f.string :email
            f.string :phone
        end
    end

end