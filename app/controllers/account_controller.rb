class AccountController < ApplicationController
    skip_before_action :verify_authenticity_token
    def new
        acc = Account.find_by(email:params[:email])
        res = []
        if !acc
            acc = Account.new(name:params[:name],email:params[:email],
            photo:params[:photo],phone:params[:phone],
            password_digest:params[:password],recovery:params[:rec],
            method:params[:method], confirmed: false, member_type: 'Temp',
            created_at: Time.now)
            if acc.save
                Logg.new(account_id:acc.id,email:acc.email,mac_address:params[:mac],time:Time.now)
                render json: {'code' => 'Success', 'message' => acc.as_json(except: [:password_digest, :recovery]), 'result' => true}
            else
                #will test this after
                render json: {'code' => 'Error: 101', 'message' => 'Database Error!', 'result' => false}
            end
        else
            render json: {'code' => 'Error: 108', 'message' => 'Account already Exists', 'result' => false}
        end
    end

    def login
        acc = Account.find_by(email:params[:em])
        if acc
            if acc.member_type != 'Premium'
                if (acc.created_at.to_date + 1.month) < Date.new && acc.member_type != 'Expired'
                    acc.member_type = 'Expired'
                    acc.save
                end
            end
            if params[:method] == 'App'
                if acc && acc.password_digest == params[:ps]
                    logg = Logg.find_by(email:acc.email)
                    if logg
                        if logg.mac_address == params[:mac]
                            render json: {'code' => 'Success', 'message' => acc.as_json(except: [:password_digest, :recovery]), 'result' => true}
                        else
                            render json: {'code' => 'Error: 107', 'message' => 'Already loggedin, on another Device', 'result' => false}
                        end
                    else
                        Logg.new(account_id:acc.id,email:acc.email,mac_address:params[:mac],time:Time.now)
                        render json: {'code' => 'Success', 'message' => acc.as_json(except: [:password_digest, :recovery]), 'result' => true}
                    end
                elsif !acc
                    render json: {'code' => 'Error: 103', 'message' => 'Account does not exist', 'result' => false}
                else
                    render json: {'code' => 'Error: 104', 'message' => 'Incorrect Password', 'result' => false}
                end
            else
                if acc 
                    render json: {'code' => 'Success', 'message' => acc.as_json(except: [:password_digest, :recovery]), 'result' => true}
                else
                    count = 0
                    pass = ''
                    str = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890!@#$%&*_+{}|:?></.,;[]\=-~'
                    while count < 15
                        num = rand(str.length - 1)
                        pass += str[num]
                        count += 1
                    end
                    acc = Account.new(name:params[:name],email:params[:email],
                        photo:params[:photo],phone:params[:phone],
                        password_digest:pass,recovery:params[:rec],
                        method:params[:method])
                        if acc.save
                            render json: {'code' => 'Success', 'message' => acc.as_json(except: [:password_digest, :recovery]), 'result' => true}
                        else
                            render json: {'code' => 'Error: 101', 'message' => 'Database Error!', 'result' => false} 
                        end
                end
            end
        else
            render json: {'code' => 'Error', 'message' => 'Account not Found!', 'result' => false}
        end
    end

    def logout
        Logg.find_by(email:params[:em]).destroy
        confirm = Logg.find_by(email:params[:em])
        if confirm
            render json: {'code' => 'Error: 101', 'message' => 'Database Error!', 'result' => false}
        else
            render json: {'code' => 'Success', 'message' => `Goodbye #{Account.find_by(email:params[:em]).name}`, 'result' => true} 
        end
    end

    def userInfo 
        acc = Account.find_by(id: params[:id])
        if acc
            render json: {'code' => 'Success', 'message' => acc.as_json(except: [:password_digest, :recovery]), 'result' => true}
        else
            render json: {'code' => 'Failed', 'message' => 'User does not exists', 'result' => false}
        end
    end

    def reqpass
        acc = Account.find_by(id: params[:id])
        if acc
            render json: {'code' => 'Success', 'message' => acc.password_digest, 'result' => true}
        else
            render json: {'code' => 'Error: 120', 'message' => 'Account not found', 'result' => false}
        end
    end 

    def passupdate
        acc = Account.find_by(email: params[:email])
        if acc
            logg = Logg.find_by(email: acc.email)
            logg.destroy if logg
            acc.password_digest = params[:password]
            if acc.save
                Logg.new(account_id:acc.id,email:acc.email,mac_address:mac,time:Time.now)
                render json: {'code' => 'Success', 'message' => acc.as_json(except: [:password_digest, :recovery]), 'result' => true}
            else
                render json: {'code' => 'Error: 101', 'message' => 'Database Error!', 'result' => false} 
            end
        else
            render json: {'code' => 'Error: 103', 'message' => 'Account does not exist', 'result' => false}
        end
    end

    def edit
        acc = Account.find_by(email: params[:em])
        if acc
            acc.name = params[:nm]
            acc.photo = params[:pt]
            acc.phone = params[:pn]
            acc.recovery = params[:re]
            if acc.save
                render json: {'code' => 'Success', 'message' => acc.as_json(except: [:password_digest, :recovery]), 'result' => true}
            else
                render json: {'code' => 'Error: 101', 'message' => 'Database Error!', 'result' => false} 
            end
        else
            render json: {'code' => 'Error: 103', 'message' => 'Account does not exist', 'result' => false}
        end
    end

    def search
        acc = Account.all
        gather = []
        acc.each do |a|
            if a.email.downcase.include?(params[:search].downcase)
                gather << a 
            elsif a.name.downcase.include?(params[:search].downcase)
                gather << a
            end
        end
        render json: {'code' => 'Success', 'message' => gather.as_json(except: [:password_digest, :recovery]), 'result' => true}
    end

    def accountrecover
        acc = Account.find_by(email: params[:em])
        if acc
            if acc.method == 'App'
                if acc.name == params[:nm] && acc.recovery == params[:pn]
                    render json: {'code' => 'Success', 'message' => 'Change Password', 'result' => true}
                else
                    render json: {'code' => 'Error: 105', 'message' => 'Provided Information does not Match', 'result' => false}
                end
            else
                render json: {'code' => 'Error: 106', 'message' => 'Google', 'result' => false}
            end
        else
            render json: {'code' => 'Error: 103', 'message' => 'Account does not exist', 'result' => false}
        end
    end

    def emailconfirm
        req = {:name => params[:name], :email => params[:email]}
        acc = Account.find_by(email: params[:email])
        if acc
            allpins = Fpin.where(account_id: acc.id).destroy_all
            count = 0
            code = ''
            str = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890'
            while count < 6
                num = rand(str.length - 1)
                code += str[num]
                count += 1
            end
            pin = Fpin.new(account_id: acc.id, code: code, time: Time.now)
            if pin.save
                NewAccountMailer.email_configuration({
                    :code => code,
                    :email => acc.email,
                    :name => acc.name
                }).deliver_now
                render json: {'code' => 'Success', 'message' => 'Check Your Email', 'result' => true}
            else
                render json: {'code' => 'Error: 101', 'message' => 'Database Error!', 'result' => false} 
            end
        else
            render json: {'code' => 'Error: 103', 'message' => 'Account does not exist', 'result' => false}
        end
    end

    def pinrecover
        acc = Account.find_by(email: params[:email])
        if acc
            if acc.method == 'App'
                allpins = Fpin.where(account_id: acc.id).destroy_all
                if acc.name == params[:name]
                    count = 0
                    code = ''
                    str = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890'
                    while count < 6
                        num = rand(str.length - 1)
                        code += str[num]
                        count += 1
                    end
                    pin = Fpin.new(account_id: acc.id, code: code, time: Time.now)
                    if pin.save
                        req = {:name => acc.name, :email => acc.email, :code => code}
                        AccountMailer.pin_confirmation(req).deliver_now
                        render json: {'code' => 'Success', 'message' => 'Check Your Email', 'result' => true}
                    else
                        render json: {'code' => 'Error: 101', 'message' => 'Database Error!', 'result' => false} 
                    end
                else
                    render json: {'code' => 'Error: 105', 'message' => 'Provided Information does not Match', 'result' => false}
                end
            else
                render json: {'code' => 'Error: 106', 'message' => 'Google', 'result' => false}
            end
        else
            render json: {'code' => 'Error: 103', 'message' => 'Account does not exist', 'result' => false}
        end
    end

    def confirmcode
        acc = Account.find_by(email: params[:email])
        pin = Fpin.find_by(account_id: acc.id)
        if pin
            if params[:code] == pin.code
                pin.destroy
                render json: {'code' => 'Success', 'message' => 'Change Password', 'result' => true}
            else
                render json: {'code' => 'Error: 107', 'message' => 'Incorrect! Try Again', 'result' => false}
            end
        else
            render json: {'code' => 'Error: 101', 'message' => 'Database Error!', 'result' => false} 
        end
    end

    def emailconfirmcode
        acc = Account.find_by(email: params[:email])
        pin = Fpin.find_by(account_id: acc.id)
        if pin
            if params[:code] == pin.code
                pin.destroy
                acc.confirmed = true
                if acc.save
                    render json: {'code' => 'Success', 'message' => 'Account Confirmed', 'result' => true}
                else
                    render json: {'code' => 'Error: 101', 'message' => 'Database Error!', 'result' => false}
                end
            else
                render json: {'code' => 'Error: 107', 'message' => 'Incorrect! Try Again', 'result' => false}
            end
        else
            render json: {'code' => 'Error: 101', 'message' => 'Database Error!', 'result' => false} 
        end
    end

    def delete
        acc = Account.find_by(id:params[:id]).destroy
        Logg.find_by(email:acc.email).destroy
        acc = Account.find_by(id:params[:id])
        if !acc
            render json: {'code' => 'Success', 'message' => 'Account Deleted', 'result' => true}
        else
            render json: {'code' => 'Error: 105', 'message' => 'Failed to Delete your Account', 'result' => false}
        end
    end
end