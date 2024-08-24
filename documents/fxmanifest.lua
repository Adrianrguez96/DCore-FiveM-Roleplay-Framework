-- Resource Metadata
fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'Dress'
description 'Documentantion system'
version '0.0.1'

ui_page 'nui/index.html'

shared_script {
    'config.lua'
}

client_scripts {
    'client/core.lua',
    'client/controller/documentcontroller.lua'
}

server_scripts {
    'server/core.lua',
    'server/controller/documentcontroller.lua'
}

files {
    'nui/index.html',
    'nui/css/*.css',
    'nui/images/*.png',
    'nui/js/*.js',
    'nui/font/FallingSky.otf',
}