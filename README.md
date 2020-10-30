# Transcendance

#install RVM and ruby
- https://rvm.io/rvm/install with rails
- rvm install "ruby-2.6.3"

#Setup docker compose
- https://ashleyconnor.co.uk/2017/07/22/local-rails-development-with-docker-and-docker-compose.html
(- Build docker img for rails : docker build --tag backend .
- docker run -it -p 3000:3000 backend)
- docker-compose up (this will build and link a backend container -rails- and a db container)
- Create database (1st time): docker-compose run backend rake db:create

Other resources for docker-compose:
https://docs.docker.com/compose/rails/ 
https://www.digitalocean.com/community/tutorials/containerizing-a-ruby-on-rails-application-for-development-with-docker-compose-fr  
https://github.com/rails/webpacker/blob/master/docs/docker.md 
https://rollout.io/blog/running-rails-development-environment-docker/ 

#Use docker volumes to save in host filesystem what is being done within container:
- docker run -itP -v $(pwd):/app IMG (https://ashleyconnor.co.uk/2017/07/22/local-rails-development-with-docker-and-docker-compose.html)

#Work in docker-compose environment
docker-compose run db psql -h db -U postgres - connect psql to our running database
docker-compose run backend console - open a rails console (works for any rails command)
-> use with -v $(pwd):/app IMG .... to mount a volume and save what is being done.

docker-compose down - stop the app
If you make changes to the Gemfile or the Compose file to try out some different configurations, you need to rebuild. Some changes require only docker-compose up --build, but a full rebuild requires a re-run of docker-compose run web bundle install to sync changes in the Gemfile.lock to the host, followed by docker-compose up --build.