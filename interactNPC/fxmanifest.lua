-- Resource Metadata
fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'Dress'
description 'Interact NPC'
version '0.0.1'

shared_script {
    'config.lua',
}


server_script {
}

ui_page 'nui/index.html'

client_scripts {
    'client/core.lua',
    'client/controller/NPCController.lua',
    'client/controller/nuicontroller.lua'
}

files {
    'nui/index.html',
    'nui/css/*.css',
    'nui/images/items/*.png',
    'nui/js/*.js'
}