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
p6 = Permission.create(name: 'view_applications',
                       description: 'Ver todas las aplicaciones', status: 1)
p7 = Permission.create(name: 'view_single_application',
                       description: 'Ver una aplicación específica', status: 1)
role = Role.create(role: 'Administrador',
                   description: 'Rol de usuario administrador del sistema de gestión de aplicaciones', status: 1)
role.permissions << [p, p2, p3, p4, p5, p6, p7]
user = User.create(username: 'drodriguezd', authentication_token: 'iYxx6xuQY_DDxornWgbA')
user.roles << role

Device.create(name: 'GT-S7710L', imei: '356850050784998', serial: '430ad2d097e2c098', wifi_mac_address: 'B0:DF:3A:74:61:C5',
              bluetooth_mac_address: 'B0:DF:3A:74:61:C4', os_version: '4.1.2', baseband_version: 'S7710LUBAND2',
              brand: 'Samsung', model: 'GT-S7710L', screen_size: '4.0', screen_resolution: '480x800', camera: '5.0',
              gmail_account: 'ssc.elfec@gmail.com', status: 2)
