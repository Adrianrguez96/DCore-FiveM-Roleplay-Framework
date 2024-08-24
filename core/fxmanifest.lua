-- Resource Metadata
fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'Dress'
description 'Core Roleplay'
version '0.0.1'

shared_script {
    'config.lua',
}


server_script {

    -- Main dependencies
    '@mysql-async/lib/MySQL.lua',
    'server/core.lua',
    'server/kernel.lua',
    'helper.lua',

    -- Libraries
    'server/library/database.lua',
    'server/library/callback.lua',
    'server/library/command.lua',

    -- Server main controller
    'server/controller/maincontroller.lua',

    -- Server controllers
    'server/controller/playercontroller.lua',
    'server/controller/bancontroller.lua',
    'server/controller/whitelistcontroller.lua',
    'server/controller/vehiclecontroller.lua',
    'server/controller/bankAccountController.lua',
    'server/controller/itemcontroller.lua',
    'server/controller/jobcontroller.lua',
    'server/controller/frameworkcontroller.lua',
    
    -- Server entities
    'server/entity/player.lua',
    'server/entity/ban.lua',
    'server/entity/whiteList.lua',
    'server/entity/vehicle.lua',
    'server/entity/bankAccount.lua',
    'server/entity/item.lua',
    'server/entity/job.lua',
   
    -- Server models
    'server/model/playermodel.lua',
    'server/model/banmodel.lua',
    'server/model/whitelistmodel.lua',
    'server/model/vehiclemodel.lua',
    'server/model/bankAccountmodel.lua',
    'server/model/itemmodel.lua',
    'server/model/jobmodel.lua'
}

ui_page 'nui/index.html'
loadscreen 'nui/loadscreen.html'

client_scripts {

    -- Main dependencies
    'client/core.lua',
    'client/kernel.lua',

    --Libraries 
    'client/library/callback.lua',
    'client/library/utility.lua',

    --Client controllers
    'client/controller/maincontroller.lua',
    'client/controller/gamecontroller.lua',
    'client/controller/playercontroller.lua',
    'client/controller/deathcontroller.lua',
    'client/controller/spawncontroller.lua',
    'client/controller/vehiclecontroller.lua',
    'client/controller/itemcontroller.lua',
    'client/controller/loopcontroller.lua',
    'client/controller/menucontroller.lua'
}

files {
    'nui/index.html',
    'nui/loadscreen.html',
    'nui/css/*.css',
    'nui/images/*.svg',
    'nui/js/*.js',
    'nui/js/wheelnav.min.js',
    'nui/js/raphael.min.js'
}

exports {
	'GetCoreObject'
}

server_exports {
	'GetCoreObject'
}