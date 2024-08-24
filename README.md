<div align="center"><img src="https://i.ibb.co/Fxgq0QH/logo.png" alt="D-Core logo"></div>

# D-Core Framework
That is a basic core framework where your are create a your own **roleplay server**. That is based in POO programing in LUA and, the nui, used HTML5, CSS3, query and javascript with standar ES6.

# Use core functions in another resourse
You can use the core functions in another resourse or modify ESX or Qbus scripts to be use the D-Core. In the case of client, you must declared the next in your first part of script or, I recommend crearte a new file lua calls **core.lua** where you separe  this part of the script logic.

**Client declaration**
 ```
Core = Core or {}

Citizen.CreateThread(function()
    while true do
        TriggerEvent("core:client:GetFramework", function(core) Core = core end)
        if Core.Status then 
            -- Here the controllers are started and the main functions of each of them are called
            break   
        end
        Wait(0)
    end
end)
 ```
**Server declaration**
```
Core = Core or {}

Citizen.CreateThread(function()
    while true do
        TriggerEvent("core:server:GetFramework", function(core) Core = core end)
        if Core.Status then 
            -- Here the controllers are started and the main functions of each of them are called
            break   
        end
        Wait(0)
    end
```

In the future, I will create a wiki where you can see the explanations of funtions that include this framework and I continue upload new versions of **D-Core** framework.

###   This is an alpha version of the framework, it can include bugs or functionalities not yet programmed or half done.
