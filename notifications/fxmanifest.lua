-- Resource Metadata
fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'Dress'
description 'Notifications kernel'
version '0.0.1'

shared_script {
}


server_script {

}

ui_page 'nui/index.html'

client_scripts {
    'client/notifications.lua',
}

lua54 'yes'

files {
    'nui/index.html',
    'nui/css/*.css',
    'nui/images/*.svg',
    'nui/js/*.js'
}