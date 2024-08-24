-- Resource Metadata
fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'Dress'
description 'Interaction Player'
version '0.0.1'

shared_script {
    'config.lua',
}


server_script {
    'server/core.lua',
    'server/controller/CommandController.lua'
}

client_scripts {
    'client/core.lua',
    'client/controller/MainInteractionController.lua',
    'client/controller/InteractionPlayerController.lua'
}