-- Resource Metadata
fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'Dress'
description 'Hud core'
version '0.0.1'

shared_script {
}


server_script {
    'server/core.lua',
    'server/controller/playerhudcontroller.lua'
}

ui_page 'nui/index.html'

client_scripts {
    'client/core.lua',
    'client/controller/playerhudcontroller.lua',
    'client/controller/vehiclehudcontroller.lua'
}

files {
    'nui/index.html',
    'nui/css/*.css',
    'nui/images/*.svg',
    'nui/images/logo.png',
    'nui/js/*.js'
}