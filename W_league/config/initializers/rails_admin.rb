RailsAdmin.config do |config|
  config.authenticate_with do
    authenticate_or_request_with_http_basic('Site Message') do |username, password|
      username == 'araki' && password == 'takaaki'
    end
  end
# 省略
end