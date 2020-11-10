# Transcendance

#This is an initial setup for transcendance project with docker-compose, with rails and backbones:
- building the image will run yarn install which will create node_modules folder and install the gems + yarn.lock. The node_modules folder is in the .gitignore so that everything can be freshly reinstalled. If need to update a module, you need to delete the folder and rebuild the image.
- the pgsql image will be built on a volume called data that will also be created during the build. It is also in the gitgnore. Therefore at first start of the db, we run "rails db:drop db:create db:migrate db:seed" (see entrypoint.sh)
- webpacker-dev-server is launched at the same time as the rails server so that it compiles in advance the css and typescript - quicker navigation afterwards
- authentification with 42 login is enabled and there are a few divs implemented with backbone.js + jquery + mustache 
- backend is on rails : there is a users table and one user that can seed the db. There are controller methods implemented for the users table. Matching routes + ones for authent are in routes.db.
- all the frontend is in the javascript folder and uses the templates in views.

#Use:
- docker-compose up (--build)
- localhost:3000
	- If there are webpacker compilation issues or gem issues : delete the volumes gem_cache and the node_modules (delete the folders), the yarn.lock and rebuild.  This will recreate the folders from scratch. (everytime there is a new module or gem added, this needs to be done)
	- if there is a database issue : delete the data folder and run in console : rails db:drop db:create db:migrate db:seed 

-------

#Setup docker compose
- https://ashleyconnor.co.uk/2017/07/22/local-rails-development-with-docker-and-docker-compose.html
- important to set up volumes for node_modules and gems otherwise yarn install will not work properly and we won't have access to the modules necessary to make 
Other resources for docker-compose:
https://docs.docker.com/compose/rails/ 
https://www.digitalocean.com/community/tutorials/containerizing-a-ruby-on-rails-application-for-development-with-docker-compose-fr  
https://rollout.io/blog/running-rails-development-environment-docker/ 

#configuration typescript et css
- install webpacker typescript compatibility : rails webpacker:install:typescript
- setup typescript import syntax in tsconfig.json
- setup typescript compatibility in config/development.js and config/environmnet.js and config/loaders/typescript.js
- setup css in postcss.config.js and tailwind.config.js
- in application.html.erb template, it will look for application.ts and application.scss files in javascript folder to startup.
- reinstalling webpacker will deconfigure all of this as webpacker is the compiler for all those things and needs to be told how to compile


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

#backbones
- doesn't have controllers : bacbone routers and views work together to pick up the functionnalities provided by rails controllers.
- collections : sets of models

Fonctionnement avec rails :
A request from a user comes in; the Rails router identifies what should
handle the request, based on the URL
• The Rails controller action to handle the request is called; some initial
processing may be performed
• The Rails view template is rendered and returned to the user’s browser
• The Rails view template will include Backbone initialization; usually this
is populating some Backbone collections as sets of Backbone models
with JSON data provided by the Rails view
• The Backbone router determines which of its methods should handle
the display, based on the URL
• The Backbone router calls that method; some initial processing may be
performed, and one or more Backbone views are rendered
• The Backbone view reads templates and uses Backbone models to render itself onto the page

Whenever a UI action causes an attribute of a model to change, the model triggers a "change" event; all the Views that display the model's state can be notified of the change, so that they are able to respond accordingly, re-rendering themselves with the new information. In a finished Backbone app, you don't have to write the glue code that looks into the DOM to find an element with a specific id, and update the HTML manually — when the model changes, the views simply update themselves.

Direction flow : BB View <=> BB Model <=> Rails Controller <=> Rails Model


#Typescript
- le javascript est un langage au typage dynamique : on peut modifier le type des données à la volée au cours de l'exécution. Source de nbeux bugs. 
- Typescript introduit dans js plusieurs types de bases + un typage statique.
- Un langage est dit de typage statique quand celui-ci vérifie les types des variables à la compilation, alors qu’un langage dit de typage dynamique, effectue cette vérification à l’exécution.
- déclaration variable avec let ou var: 
```ts
let myVar: boolean;  //default value is false
let myVarinitialize: number = 2;
var bar = "hello world"; //typage implicite reste possible
```
- variable de type any : permet typage dynamique de js : on peut changer son type en cours d'execution
- template string : 
```ts 
var template: string = `My var is: ${var}`;
```
- en typescript, erreurs de compilation si mauvais type passé en param
- une fonction qui prend une string :
```ts 
function f(name: string): string { //deuxième partie indique que la fonction return string
   return name;
}
```
- fonction avec paramètres optionnels : function f(name: string, option?: string): string
- arrays : two ways :
```ts
var names: string[] = [“Pierre”,”Paul”,”Jaques”];
var otherNames: Array<string> = [“Pierre”,”Paul”,”Jaques”];
```

- interfaces : permet de définir des conditions (propriétés/méthodes) requises pour un objet :
```ts
interface IPerson{  
   firstName: string;
   lastName: string;
}
```
Pour qu'un objet satisfasse cette interface, il doit contenir au moins toutes les propriétés et méthodes de cette interface.
Une fonction peut prendre en paramètre une interface, et dès lors cherchera dans l'objet qui lui est passé si respect de l'interface. 
Possible qu'une interface hérite d'une autre.

- typescript permet aussi d'utiliser des classes. pour accéder aux variables de classes : this.var. Héritage via mot-clé extends. 

- Modules : équivalent d'un namespace : regroupement logique de classes et d'interfaces qui permet de structurer un projet. Le module se déclare à l'aide de 'export module Module1 {}'. Les modules peuvent aussi bien exposer des classes que des fonctions, des constantes ou des interfaces.
Ex utilisation : 
```ts
import {Module1} from './app/module1'
let md = new Module1.Person();
md.greeting();
let person : Module1.IGreeter = md;
```
- on peut aussi utiliser un module sans le mot-clé module, en considérant que tout ce qui est dans un fichier est un module( bien mettre export devant chaque fonction/methodes/variable) et dans le fichier qui va utiliser le module : import m = require("./module2");

#Doc typescript : 
https://blog.cellenza.com/developpement-specifique/web-developpement-specifique/introduction-a-typescript/ 
https://yahiko.developpez.com/tutoriels/introduction-typescript/
