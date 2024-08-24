function GetCoreObject()
	return Core
end

RegisterNetEvent('core:client:GetFramework')
AddEventHandler('core:client:GetFramework', function(cb)
	cb(GetCoreObject())
end)
