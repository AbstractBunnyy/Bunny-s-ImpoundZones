fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'bunnys-impoundZone'
author 'Unknown and Bunny'
version '1.0'

shared_script 'config.lua'

client_scripts {
	'client.lua',
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/ComboZone.lua'
}
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua'
}

dependencies {
    'qb-core',
    'PolyZone'
}
 