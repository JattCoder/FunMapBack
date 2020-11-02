class SettingController < ApplicationController
    skip_before_action :verify_authenticity_token

    def settings
        settings = Setting.find_by(user_id: params[:id])
        if settings
            render json: {'code' => 'Success', 'message' => settings, 'result' => true}
        else
            settings = Setting.new(user_id: params[:id], drivingMode: 'driving', permitted: 'Ghost', highways: false, tolls: false, ferries: false, temperature: 'F°', backgroundColor: '', familySelection: 0)
            if settings.save
                render json: {'code' => 'Success', 'message' => settings, 'result' => true}
            else
                render json: {'code' => 'Error', 'message' => 'Account Error', 'result' => false}
            end
        end
    end

    def locShare
        settings = Setting.find_by(user_id: params[:id])
        if settings
            settings.permitted = params[:locShare]
            if settings.save
                render json: {'code' => 'Success', 'message' => settings.permitted, 'result' => true}
            else
                render json: {'code' => 'Error', 'message' => 'Failed', 'result' => false}
            end
        else
            render json: {'code' => 'Error', 'message' => 'Account Error', 'result' => false}
        end
    end

    def backColor
        settings = Setting.find_by(user_id: params[:id])
        if settings
            settings.backgroundColor = params[:backColor]
            if settings.save
                render json: {'code' => 'Success', 'message' => 'Success', 'result' => true}
            else
                render json: {'code' => 'Error', 'message' => 'Failed', 'result' => false}
            end
        else
            render json: {'code' => 'Error', 'message' => 'Account Error', 'result' => false}
        end
    end

    def famSelection
        settings = Setting.find_by(user_id: params[:id])
        if settings
            settings.familySelection = params[:famSelection]
            if settings.save
                render json: {'code' => 'Success', 'message' => 'Success', 'result' => true}
            else
                render json: {'code' => 'Error', 'message' => 'Failed', 'result' => false}
            end
        else
            render json: {'code' => 'Error', 'message' => 'Account Error', 'result' => false}
        end
    end

    def updateSettings
        settings = Setting.find_by(user_id: params[:id])
        if settings
            settings.drivingMode = params[:drivingMode]
            settings.highways = params[:highways]
            settings.tolls = params[:tolls]
            settings.ferries = params[:ferries]
            settings.temperature = params[:temperature]
            if settings.save
                render json: {'code' => 'Success', 'message' => 'Success', 'result' => true}
            else
                render json: {'code' => 'Error', 'message' => 'Failed to Update', 'result' => false}
            end
        else
            render json: {'code' => 'Error', 'message' => 'Account Error', 'result' => false}
        end
    end

end