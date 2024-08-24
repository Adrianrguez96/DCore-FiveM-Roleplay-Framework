function GetCoreObject()
	return Core
end

RegisterServerEvent('core:server:GetFramework')
AddEventHandler('core:server:GetFramework', function(cb)
	cb(GetCoreObject())
end)