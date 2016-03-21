#encoding: utf-8
# This file should contain all the record creation needed to seed the database on development environment
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
role = Role.create(role: 'Administrador',
                   description: 'Rol de usuario administrador del sistema de gestión de aplicaciones', status: 1)
role.permissions << [p, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16]

Policy.create(type: Policy.types[:application_control], name: 'Directivas de control de aplicaciones',
              description: 'Utilize estas directivas para poder definir que aplicaciones estan permitidas/denegadas,
de usar un usuario o un grupo de usuarios')
Policy.create(type: Policy.types[:device_restriction], name: 'Directivas de restricción de dispositivos',
              description: 'Utilize estas directivas para poder definir que usuarios o grupos de usuarios tienen acceso
a que dispositivos')

user = User.create(username: 'drodriguez', authentication_token: '_rD46PrUrWDaxfyQGyDK',
                   last_ad_sync_at: Time.now,status: 1)
user.roles << role

Device.create(name: 'GT-S7710L', imei: '356850050784998', serial: '430ad2d097e2c098', wifi_mac_address: 'B0:DF:3A:74:61:C5',
              bluetooth_mac_address: 'B0:DF:3A:74:61:C4', os_version: '4.1.2', baseband_version: 'S7710LUBAND2',
              brand: 'Samsung', model: 'GT-S7710L', screen_size: '4.0', screen_resolution: '480x800', camera: '5.0',
              gmail_account: 'ssc.elfec@gmail.com', status: 2)

app1 = Application.create!(name: 'Elfec Lecturas',
                          package: 'com.elfec.lecturas',
                          status: 1)
app1.app_versions.create(version: '1.0.1', version_code: 1, status: 1)

app2 = Application.create!(name: 'Lecturas Gran Demanda',
                          package: 'com.elfec.lecturas.gd', status: 1)
app2.app_versions.create!(version: '1.0.0', version_code: 1, status: 1)