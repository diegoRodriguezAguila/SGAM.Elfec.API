# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
permission = Permission.create(name: 'ACCESO_APP_ADMINISTRADOR',
                               description: 'Acceso al sistema de gestión de aplicaciones móviles', status: 1)
role = Role.create(role: 'Administrador',
                   description: 'Rol de usuario administrador del sistema de gestión de aplicaciones', status: 1)
role.permissions << permission
user = User.create(name: 'drodriguezd')
user.roles << role
