#encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
permission = Permission.create(name: 'ADMIN_APP_ACCESS',
                               description: 'Acceso al sistema de gestión de aplicaciones móviles', status: 1)
role = Role.create(role: 'Administrador',
                   description: 'Rol de usuario administrador del sistema de gestión de aplicaciones', status: 1)
role.permissions << permission
user = User.create(username: 'drodriguezd')
user.roles << role
