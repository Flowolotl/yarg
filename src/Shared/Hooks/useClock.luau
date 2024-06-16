local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local React = require(ReplicatedStorage.Packages.react)

local function useClock(): React.Binding<number>
    local clockBinding, setClockBinding = React.useBinding(0)

    React.useEffect(function()
        local stepConnection = RunService.PostSimulation:Connect(function(delta)
            setClockBinding(clockBinding:getValue() + delta)
        end)

        return function()
            stepConnection:Disconnect()
        end
    end, {})
    
    local reset = function()
        setClockBinding(0)
    end

    return clockBinding, reset
end

return useClock