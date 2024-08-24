-- Resource Metadata
fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'Dress'
description 'Banking system roleplay'
version '0.0.1'

shared_script {
    'config.lua',
}


server_script {
    'server/core.lua',
    'server/controller/bankcontroller.lua'
}

ui_page 'nui/index.html'

client_scripts {
    'client/core.lua',
    'client/controller/bankcontroller.lua',
    'client/controller/nuicontroller.lua',
}

files {
    'nui/index.html',
    'nui/css/*.css',
    'nui/images/*.png',
    'nui/js/*.js'
}