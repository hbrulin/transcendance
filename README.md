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
- docker-compose run backend rails console - open a rails console (works for any rails command)
- docker exec -it xxxxxxx bin/rails c // same but while running with docker compose up
https://blog.eq8.eu/til/how-to-lunch-rails-console-in-specific-docker-container.html 
- docker exec -it xxxxxxx sh enter container with launching any console

#Sharefiled system
-> with docker run or docker-compose up, use with -v $(pwd):/app IMG .... to mount a volume and save what is being done
-> Ici pas besoin car volume monté dans le docker-compose yaml file.
-> setting a volume sets up a shared filesystem between our host and container : ce qui est dans app va être modifié.
-> c'est la même chose pour db, dans le docker-compose on a monté un volume.

#Stopping and rebuilding
docker-compose down - stop the app
If you make changes to the Gemfile or the Compose file to try out some different configurations, you need to rebuild. Some changes require only docker-compose up --build, but a full rebuild requires a re-run of docker-compose run web bundle install to sync changes in the Gemfile.lock to the host, followed by docker-compose up --build.

#Migration
https://guides.rubyonrails.org/v3.2/migrations.html
- le dossier db contient les migrations
- on peut générer les fichiers : rails g migration CreateTableName title:string
- puis rails db:migrate
- evite d'avoir à utiliser la console pg


#CRUD
https://medium.com/@nancydo7/ruby-on-rails-crud-tutorial-899117710c7a
- docker exec -it xxxxxxx sh
- Generate a model : Models talk to the database, store and validate data.
	rails g model user name guild_id banned (name of model always singular / add fields after)
- This creates two files : 
	app/models/user.rb
	db/migrate/[date_time]_create_users.rb
- generate a controller : a controller coordinates interaction between the user, the views and the model. gets request from view and coordinates with model
	rails g controller users index show new edit (controllers' names should be plural)
- This creates:
	- a controller file : users_controller.rb
	- it updates the routes.rb file with new routes
	- 4 new files in views
- in routes.rb, remove the news routes and replace with "resources :users" - this creates routes corresponding to the different controllers
- eventually update the migrate file so that the table will be migrated with the right fields
- rake db:migrate . This will create the table in our SQLite database based on what is in our db/migrate/[date_time]_create_users.rb file.
- Add some users in db/migrate/seeds.rb to test
- check in rails console
- see all routes the app is configured to : http://localhost:3000/rails/info/routes
- To read this data (ex to list all users): 
	- update the index method of users_controller.rb : @users = User.all. when the corresponding index route is called, the index method will be called (note that routes are made from resources :users - no need to define them one by one, one was made for each controller, but you can see them in above url)
	- update the index view file with an iteration on each user and a link that will go the the show view for each user : the link takes the route called user_path which corresponds to /users/:id (as shown in the routes displayed on localhost:3000/rails/info/routes)
	- localhost:3000/users displays it (as seen in the display of routes : the route called users_path is /users translated in URI)
	- update the show method of controller and the show view to display info and access it with localhost:3000/user/ID
	- then update controller with new, create and user_params methods (to define which are required) + update the view to have a form. Look at the new_user_path : the uri is /users/new.
	- pourquoi il y a deux forms dans la view? 
	- Same with edit.
	- add a destroy controller and update show view to use it

#update structure d'une table de la db
- generate migration
- in file use method change_table :TABLE do |t|
- define what to do https://riptutorial.com/ruby-on-rails/example/5849/changing-tables
- rake db:migrate

#Global fonctionnement
- browser sends a request to server
- rails gets request and follows the method listed in routes list (get, delete, post etc..) - matches it with appropriate route
- when it finds the route, it maps it to the method in controller and calls it
- from there, it finds the associated view page and displays
https://betterexplained.com/articles/intermediate-rails-understanding-models-views-and-controllers/ 

#Configure pg_admin
- log_in with env variables defined in docker-compose for pg_admin 
- add a server : choose name and go to connection tab
- Host_name/address : use the name of container pgsql : db (host value in database.yml)
- port : 5432 (see with docker ps of configure it with env variable in database.yml)
- Maintenance databse : name of the database - could be set in env variable of database.yml, but here it is postgres (use \list in pqsgl console to list databses)
- username and password configured for pgsql database in database.yml
- aller dans la db transcendance developpement, schemas, puis tables


#see databases
- open to psql console : docker-compose run db psql -h db -U postgres
- \list

#add backbones
- remove turbolinks in gemfile cuz it breaks in backbone + package.json
- same in app/javascript/application.js
- same in app views layouts/applications : remove the town turbolink data
- add backbone to 
