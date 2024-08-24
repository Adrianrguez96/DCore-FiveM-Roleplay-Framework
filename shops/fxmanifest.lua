-- Resource Metadata
fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'Dress'
description 'Jobs system roleplay'
version '0.0.1'

shared_script {
    'config.lua',
}

server_script {
    'server/core.lua',
}

ui_page 'nui/index.html'

client_scripts {
    'client/core.lua',
    'client/controller/clotherShopController.lua',
    'client/controller/nuiController.lua'
}

files {
    'nui/index.html',
    'nui/css/*.css',
    'nui/image/clother/*.svg',
    'nui/js/*.js'
}