# Transcendance

#install RVM and ruby
- https://rvm.io/rvm/install with rails

#Docker cmds (not used)
- Build docker img for rails : docker build --tag backend .
- docker run -it -p 3000:3000 backend)
- Use docker volumes to save in host filesystem what is being done within container:
	- docker run -itP -v $(pwd):/app IMG (https://ashleyconnor.co.uk/2017/07/22/local-rails-development-with-docker-and-docker-compose.html)


#Setup docker compose
- https://ashleyconnor.co.uk/2017/07/22/local-rails-development-with-docker-and-docker-compose.html
- docker-compose up (this will build and link a backend container -rails- and a db container)
- Create database (1st time): docker-compose run backend rake db:create
Other resources for docker-compose:
https://docs.docker.com/compose/rails/ 
https://www.digitalocean.com/community/tutorials/containerizing-a-ruby-on-rails-application-for-development-with-docker-compose-fr  
https://rollout.io/blog/running-rails-development-environment-docker/ 

#Work in docker-compose environment
- docker-compose up / docker-compose up --build
- docker-compose run db psql -h db -U postgres - connect psql to our running database
- docker-compose run backend console - open a rails console (works for any rails command)

#Sharefiled system
-> with docker run or docker-compose up, use with -v $(pwd):/app IMG .... to mount a volume and save what is being done
-> Ici pas besoin car volume monté dans le docker-compose yaml file.
-> setting a volume sets up a shared filesystem between our host and container : ce qui est dans app va être modifié.
-> c'est la même chose pour db, dans le docker-compose on a monté un volume.

#Stopping and rebuilding
docker-compose down - stop the app
If you make changes to the Gemfile or the Compose file to try out some different configurations, you need to rebuild. Some changes require only docker-compose up --build, but a full rebuild requires a re-run of docker-compose run web bundle install to sync changes in the Gemfile.lock to the host, followed by docker-compose up --build.

#fonctionnement rails:
- define route
- define controller lié à la route
- define view appelee par controller -> remplace par backbone

#Migration
https://guides.rubyonrails.org/v3.2/migrations.html
- le dossier db contient les migrations
- on peut générer les fichiers : rails g migration CreateTableName title:string
- puis rails db:migrate
- evite d'avoir à utiliser la console pg