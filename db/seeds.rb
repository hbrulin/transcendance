# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(name: 'Blabla', guild_id: 1, banned: false, status: 0, admin: false)
User.create(name: 'Bloublou', guild_id: 2, banned: false, status: 1, admin: false)
User.create(name: 'Blibli', guild_id: 3, banned: true, status: 0, admin: false)
User.create(name: 'Blobloblo', guild_id: 4, banned: false, status: 0, admin: true)
