#encoding: utf-8
# This file should contain all the record creation needed to seed the database on test environment
p = Permission.create(name: 'admin_app_access',
                      description: 'Acceder al sistema de gestión de aplicaciones móviles', status: 1)
p2 = Permission.create(name: 'register_device',
                       description: 'Registrar un nuevo dispositivo', status: 1)
p3 = Permission.create(name: 'view_devices',
                       description: 'Ver todos los dispositivos', status: 1)
p4 = Permission.create(name: 'view_single_device',
                       description: 'Ver un dispositivo específico', status: 1)
p5 = Permission.create(name: 'update_device',
                       description: 'Actualizar los datos de un dispositivo', status: 1)
p6 = Permission.create(name: 'register_application',
                       description: 'Registrar una nueva aplicación', status: 1)
p7 = Permission.create(name: 'view_applications',
                       description: 'Ver todas las aplicaciones', status: 1)
p8 = Permission.create(name: 'view_single_application',
                       description: 'Ver una aplicación específica', status: 1)
p9 = Permission.create(name: 'register_user',
                       description: 'Registrar un nuevo usuario', status: 1)
p10 = Permission.create(name: 'view_users',
                        description: 'Ver todos los usuarios', status: 1)
p11 = Permission.create(name: 'view_single_user',
                        description: 'Ver un usuario específico', status: 1)
p12 = Permission.create(name: 'download_application',
                        description: 'Descargar aplicaciones', status: 1)
role = Role.create(role: 'Administrador',
                   description: 'Rol de usuario administrador del sistema de gestión de aplicaciones', status: 1)
role.permissions << [p, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12]