class CreateLoggedin < ActiveRecord::Migration[5.0]
    def change
        create_table :loggs do |a|
            a.string :account_id
            a.string :email
            a.string :mac_address
            a.string :time
        end
    end
end