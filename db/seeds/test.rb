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
p13 = Permission.create(name: 'register_user_group',
                        description: 'Registrar un nuevo grupo de usuarios', status: 1)
p14 = Permission.create(name: 'view_user_groups',
                        description: 'Ver todos los grupos de usuarios', status: 1)
p15 = Permission.create(name: 'view_single_user_group',
                        description: 'Ver un grupo de usuarios específico', status: 1)
p16 = Permission.create(name: 'update_user_group',
                        description: 'Actualizar los datos de un grupo de usuarios', status: 1)
p17 = Permission.create(name: 'register_whitelist',
                        description: 'Registrar una nueva whitelist de aplicaciones', status: 1)
p18 = Permission.create(name: 'view_whitelists',
                        description: 'Ver todas las whitelist de aplicaciones', status: 1)
p19 = Permission.create(name: 'view_single_whitelist',
                        description: 'Ver una whitelist de aplicaciones específica', status: 1)
p20 = Permission.create(name: 'update_whitelist',
                        description: 'Actualizar los datos de una whitelist de aplicaciones', status: 1)
role = Role.create(role: 'Administrador',
                   description: 'Rol de usuario administrador del sistema de gestión de aplicaciones', status: 1)
role.permissions << [p, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20]
