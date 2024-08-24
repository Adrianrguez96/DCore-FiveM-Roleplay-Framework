-- Resource Metadata
fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'Dress'
description 'Inventory'
version '0.0.1'

shared_script {
    'config.lua',
}


server_script {
    'server/core.lua',
    'server/controller/inventorycontroller.lua'
}

ui_page 'nui/index.html'

client_scripts {
    'client/core.lua',
    'client/controller/inventorycontroller.lua',
    'client/controller/nuicontroller.lua'
}

files {
    'nui/index.html',
    'nui/css/*.css',
    'nui/images/items/*.png',
    'nui/js/*.js'
}