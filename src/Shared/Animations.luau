local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Easings = require(ReplicatedStorage.Shared.Easings)
local React = require(ReplicatedStorage.Packages.react)
local UDim2Multiply = require(ReplicatedStorage.Shared.UDim2Multiply)

export type AnimationsImpl<T> = {
	__index: AnimationsImpl<T>,
	new: (clock: React.Binding<number>, native: { [string]: any, property1: string }, target: T, property: string) -> Animations<T>,
	Forward: (self: Animations<T>, easing: Easings.Easing, time: number) -> React.Binding<T>,
	Reverse: (self: Animations<T>, easing: Easings.Easing, time: number) -> React.Binding<T>
}

export type Animations<T> = typeof(setmetatable({} :: { clock: React.Binding<number>, native: { [string]: any }, property1: T, property2: T }, {} :: AnimationsImpl<T>))

local Animations = {} :: AnimationsImpl<any>
Animations.__index = Animations

--[=[
	@class Animations
	@constructor Animations.new(basePos: UDim2, baseSize: UDim2, clock: React.Binding<number>)
	@param clock React.Binding<number>
	@param native { T }
	@param target { T }
	@return Animations
	Creates a new Animations object. Used to animate GUI elements. Uses the useClock() binding to get time for animation progress.
--]=]

function new<T>(clock, native, target, property) : Animations<T>
	local self = setmetatable({}, Animations)
	self.clock = clock
	self.native = native
	self.property1 = native[property]
	self.property2 = target
	return self
end

--[=[
	@param easing Easings.Easing
	@param time number
	@return React.Binding<T>
	Creates a react binding that returns a smoothly interpolated value between the native and target values.
--]=]

function Animations:Forward(easing, time)
	return self.clock:map(function(currentTime: number)
		local completionPercentage = math.clamp(currentTime / time, 0, 1)
		local easedCompletionPercentage = easing(completionPercentage)
		local difference = (self.property2 - self.property1)
		local displacement: UDim2 | number
		if typeof(difference) == "number" then
			displacement = difference * easedCompletionPercentage
		elseif typeof(difference) == "UDim2" then
			displacement = UDim2Multiply(difference :: UDim2, easedCompletionPercentage)
		end
		local newValue = self.property1 + displacement 
		return newValue
	end)
end

--[=[
	@param easing Easings.Easing
	@param time number
	@return React.Binding<T>
	Same as Forward, but swaps the native and target values.
--]=]

function Animations:Reverse(easing, time)
	return self.clock:map(function(currentTime: number)
		local completionPercentage = math.clamp(currentTime / time, 0, 1)
		local easedCompletionPercentage = easing(completionPercentage)
		local difference = (self.property1 - self.property2)
		local displacement: UDim2 | number
		if typeof(difference) == "number" then
			displacement = difference * easedCompletionPercentage
		elseif typeof(difference) == "UDim2" then
			displacement = UDim2Multiply(difference :: UDim2, easedCompletionPercentage)
		end
		local newValue = self.property2 + displacement 
		return newValue
	end)
end

return {
	new = new,
}
