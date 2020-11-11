rm -f tmp/pids/server.pid
rails db:drop db:create db:migrate db:seed
#./bin/webpack-dev-server & //add to fasten compilation but causes CORS pb
bin/rails s -b 0.0.0.0
