Core = {}

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(7)
		if NetworkIsSessionStarted() then
			Citizen.Wait(10)
			--Load Game Controller 
			MainController = MainController()
			MainController.init()
			Core = MainController
			
			--Add libraries 
			Core.Callback = Callback()
			Core.Callback.init()
			Core.Utility = Utility()

			Core.Status = true
			break
		end
	end
end)