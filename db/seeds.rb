#encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
p = Permission.create(name: 'admin_app_access',
                               description: 'Acceso al sistema de gestión de aplicaciones móviles', status: 1)
p2 = Permission.create(name: 'register_device',
                               description: 'Registro de un nuevo dispositivo', status: 1)
p3 = Permission.create(name: 'view_devices',
                                description: 'Ver de todos los dispositivos', status: 1)
p4 = Permission.create(name: 'view_single_device',
                       description: 'Ver un dispositivo específico', status: 1)
role = Role.create(role: 'Administrador',
                   description: 'Rol de usuario administrador del sistema de gestión de aplicaciones', status: 1)
role.permissions << [p, p2, p3, p4]
user = User.create(username: 'drodriguezd')
user.roles << role
