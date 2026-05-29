class ApplicationController < ActionController::Base

    # 1.9helloの追加
    def hello
        render html: "hello, world!"
    end

end
