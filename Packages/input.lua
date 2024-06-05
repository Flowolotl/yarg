local test = require(script.Parent._Index["sleitnick_input@2.3.0"]["input"])

-- inject GetKeysDown into Keyboard because i need it !!!
local _uis = game:GetService("UserInputService")
local Map = require(game:GetService("ReplicatedStorage").Shared.Map)
function test.Keyboard:GetKeysDown()
    return Map(_uis:GetKeysPressed(), function(key)
        return key.KeyCode.Name
    end)
end

return test
