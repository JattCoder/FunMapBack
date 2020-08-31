class TestController < ApplicationController

    def test
        render json: {'message' => 'Home Screen'}
    end

end