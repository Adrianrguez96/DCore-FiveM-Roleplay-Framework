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
    'server/controller/jobcontroller.lua'
}

client_scripts {
    'client/core.lua',
    'client/controller/jobcontroller.lua',
    'client/controller/policecontroller.lua',
    'client/controller/mediccontroller.lua',
    'client/controller/governmentcontroller.lua',
    'client/controller/ilegalcontroller.lua'
}