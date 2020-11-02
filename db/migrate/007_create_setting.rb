class CreateSetting < ActiveRecord::Migration[5.0]

    def change
        create_table :settings do |s|
            s.integer :user_id
            s.string :drivingMode
            s.string :permitted
            s.boolean :highways
            s.boolean :tolls
            s.boolean :ferries
            s.string :temperature
            s.string :backgroundColor
            s.integer :familySelection
        end
    end

end