-- Resource Metadata
fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'Dress'
description 'Vehicle system'
version '0.0.1'

shared_script {
}


server_script {
    'server/core.lua',
}

ui_page 'nui/index.html'

client_scripts {
    'client/core.lua',
    'client/controller/BasicVehicleController.lua',
}