# Transcendance

#install RVM and ruby
- https://rvm.io/rvm/install with rails
- rvm install "ruby-2.6.3"

#Setup docker compose
- https://ashleyconnor.co.uk/2017/07/22/local-rails-development-with-docker-and-docker-compose.html
- Build docker img for rails : docker build --tag transcendance .
- docker run -it -p 3000:3000 transcendance

Other resources for docker-compose:
https://docs.docker.com/compose/rails/ 
https://www.digitalocean.com/community/tutorials/containerizing-a-ruby-on-rails-application-for-development-with-docker-compose-fr  
https://github.com/rails/webpacker/blob/master/docs/docker.md 