--!strict
local React = require(game:GetService("ReplicatedStorage").Packages.react)
type ReactBinding = React.ReactBinding<number>
local State = require(game:GetService("StarterPlayer").StarterPlayerScripts.Game.State)
local Universal = require(script.Parent.Dimensions).Universal
type UniDim = Universal.UniDim
local Animations = {}
Animations.__index = Animations

--temp
-- extract to own file/class/enum/whatever after done

local function easeOutQuart(x)
    return 1 - math.pow(1 - x, 4)
end

local function easeOutCubic(x)
    return 1 - math.pow(1 - x, 3)
end

local function easeInCubic(x)
    return math.pow(x, 3)
end

local function easeInSine(x)
    return 1 - math.cos(x * math.pi / 2)
end

local function easeOutSine(x)
    return math.sin(x * math.pi / 2)
end

local function easeInOutQuint(x)
    return x < 0.5 and 8 * x * x * x * x * x or 1 + 8 * (1 - x) * (1 - x) * (1 - x) * (1 - x) * (1 - x)
end

-- end

export type Animations = {
    basePos: UniDim,
    baseSize: UDim2,
    clock: ReactBinding,
    SlideDown: (time: number) -> UDim2,
    Transparency: (time: number) -> UDim2,
}

function new(basePos: Universal.UniDim, baseSize: UDim2, clock: ReactBinding): Animations
    local self = setmetatable({}, Animations)
    self.basePos = basePos
    self.baseSize = baseSize
    self.clock = clock
    return self
end

function Animations:SlideDown(time: number): UDim2
    --TODO: make a more complete solution. this one doesn't ASSUMES anchor point is 0.5, 0.5 and is using Scale instead of offset. Need to account for anchor point and probably convert all to either scale or offset. Maybe a wrapper for the scale/offset?
    return self.clock:map(function(clock: number)
        local startPos: UDim2 = self.basePos.Base
        local val = math.clamp(clock / time, 0, 1)
        val = easeInOutQuint(val)
        local endPos = UDim2.new(0, 0, 1, 0) + UDim2.new(0, 0, self.baseSize.Y.Scale, 0)
        local f = (endPos.Y.Scale - startPos.Y.Scale) * val
        return UDim2.new(startPos.X.Scale, 0, startPos.Y.Scale + f, 0)
    end)
end

function Animations:Transparency(time: number): UDim2
    return self.clock:map(function(clock: number)
        return math.clamp(easeOutSine(clock / time), 0, 1)
    end)
end

return {
    new = new,
}