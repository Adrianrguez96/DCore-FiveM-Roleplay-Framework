<div align="center"><img src="https://i.ibb.co/Fxgq0QH/logo.png" alt="D-Core logo"></div>

# D-Core Framework
D-Core Framework is a foundational core designed to help you create and manage your own roleplay server on FiveM. Built with an object-oriented programming (OOP) approach in Lua, D-Core utilizes modern web technologies such as HTML5, CSS3, jQuery, and ES6 JavaScript for its NUI (New User Interface).

## Features
- Object-Oriented Programming: D-Core leverages Lua's OOP capabilities, allowing for clean, modular, and maintainable code.
- Modern Web Technologies: The NUI components are built using HTML5, CSS3, jQuery, and JavaScript (ES6), ensuring a responsive and dynamic user interface.
- Flexible Integration: Easily integrate D-Core with other resources or modify existing scripts like ESX or Qbus to work seamlessly with D-Core.

# Using Core Functions in Other Resources
D-Core's core functions can be integrated into other resources or modified scripts to enhance your server's capabilities. Below are the basic declarations needed to start using D-Core in your client and server scripts.

## Client-Side Declaration
To use D-Core functions on the client side, add the following code at the beginning of your script. It's recommended to create a separate file, core.lua, where you can manage this part of your script logic.

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
 ## Server-Side Declaration
Similarly, to use D-Core functions on the server side, include the following code:

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

# Important Note

This is an alpha version of the framework, which means it may contain bugs or incomplete features. Your feedback and contributions are welcome as the framework continues to evolve.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


