local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Easings = require(ReplicatedStorage.Shared.Easings)
local React = require(ReplicatedStorage.Packages.react)
local UniDim = require(ReplicatedStorage.Shared.UniDim)

type NumberReactBinding = React.Binding<number>
type UniDim = UniDim.UniDim
type Easing = Easings.Easing

export type AnimationsImpl = {
	__index: AnimationsImpl,
	new: (clock: NumberReactBinding) -> Animations,
	Slide: (self: Animations, animationData: AnimationData) -> React.Binding<UDim2>,
	Transform: (self: Animations, animationData: AnimationData) -> React.Binding<UDim2>,
	Transparency: (self: Animations, animationData: AnimationData) -> React.Binding<number>,
	Reverse: (self: Animations, animationData: AnimationData) -> React.Binding<UDim2> | React.Binding<number>,
}

export type Animations = typeof(setmetatable({} :: { clock: NumberReactBinding }, {} :: AnimationsImpl))

export type AnimationData = {
	timeToComplete: number,
	easing: Easing,
	start: UDim2 | number,
	endpoint: Endpoint | UDim2 | number,
	type: AnimationType,
	size: UDim2?,
}

export type AnimationType = "Position" | "Size" | "Transparency"

export type Endpoint = "Down" | "Up" | "Left" | "Right"

local Animations = {} :: AnimationsImpl
Animations.__index = Animations

local Endpoints = {
	Down = function(basePos: UDim2, baseSize: UDim2)
		return UDim2.new(basePos.X.Scale, 0, 1, 0) + UDim2.new(0, 0, baseSize.Y.Scale, 0)
	end,
	Up = function(basePos: UDim2, baseSize: UDim2)
		return UDim2.new(basePos.X.Scale, 0, 0, 0) - UDim2.new(0, 0, baseSize.Y.Scale, 0)
	end,
}

--[=[
	@class Animations
	@constructor Animations.new(basePos: UDim2, baseSize: UDim2, clock: NumberReactBinding)
	@param clock NumberReactBinding
	@return Animations
	Creates a new Animations object. Used to animate GUI elements. Uses the useClock() binding to get time for animation progress.

	```lua
	local useClock = require(ReplicatedStorage.Shared.Hooks.useClock)
	local _animations: Animation = Animations.new(UDim2.new(0.5, 0, 0.5, 0), UDim2.new(0.1, 0, 0.1, 0), 0, useClock()) :: Animations
	```
--]=]

function new(clock: NumberReactBinding): Animations
	local self = setmetatable({}, Animations)
	self.clock = clock
	return self
end

function Animations:Reverse(animationData)
	if animationData.type == "Position" then
		local endPos = if typeof(animationData.endpoint) == "string"
			then Endpoints[animationData.endpoint](animationData.start, animationData.size)
			else animationData.endpoint
		-- swap because reversing. this is likely bad practice
		animationData.start, animationData.endpoint = endPos, animationData.start

		return self:Slide(animationData)
	elseif animationData.type == "Size" then
		-- swap because reversing. this is likely bad practice
		animationData.start, animationData.endpoint = animationData.endpoint, animationData.start
		return self:Transform(animationData)
	elseif animationData.type == "Transparency" then
		-- swap because reversing. this is likely bad practice
		animationData.start, animationData.endpoint = animationData.endpoint, animationData.start
		return self:Transparency(animationData)
	end
	return nil :: never
end

--[=[
	@param animationData AnimationData
	@return React.Binding<UDim2>
	Creates a react binding that calculates the new position for an object to slide to the endPos position over time.

	```lua
	local basePosition = UDim2.new(0.5, 0, 0.5, 0)
	local baseSize = UDim2.new(0.1, 0, 0.1, 0)
	local animations: Animations = React.useState(_animations)

	local endPosition = UDim2.new(0.7, 0, 0.2, 0)

	return ce(Pane, {
		native = {
			Position = sliding and animations:Slide(timeToComplete, Easings.Quint.InOut, endPosition) or basePosition,
			Size = baseSize,
			AnchorPoint = Vector2.new(0.5, 0.5),
		}
	})
	```
]=]

function Animations:Slide(animationData)
	assert(typeof(animationData.start) == "UDim2", "Animations:Slide requires animationData.start to be UDim2")
	local startPos = animationData.start
	local endPos = if typeof(animationData.endpoint) == "string"
		then Endpoints[animationData.endpoint](animationData.start, animationData.size)
		else animationData.endpoint
	return self.clock:map(function(currentTime: number)
		local completionPercentage = math.clamp(currentTime / animationData.timeToComplete, 0, 1)
		local easedCompletionPercentage = animationData.easing(completionPercentage)
		local distance = (endPos - startPos)
		local displacement = UniDim.Wrap(distance):MultiplyRaw(easedCompletionPercentage) :: UDim2
		local newPos = startPos + displacement
		return newPos
	end)
end

function Animations:Transform(animationData)
	assert(typeof(animationData.start) == "UDim2", "Animations:Transform requires animationData.start to be UDim2")
	local startSize = animationData.start
	local endSize = if typeof(animationData.endpoint) == "UDim2" then animationData.endpoint else animationData.start
	return self.clock:map(function(currentTime: number)
		local completionPercentage = math.clamp(currentTime / animationData.timeToComplete, 0, 1)
		local easedCompletionPercentage = animationData.easing(completionPercentage)
		local difference = (endSize - startSize)
		local displacement = UniDim.Wrap(difference):MultiplyRaw(easedCompletionPercentage) :: UDim2
		local newSize = startSize + displacement
		return newSize
	end)
end

--[=[
	@param animationData AnimationData
	@return React.Binding<number>
	Creates a react binding that calculates the new transparency for an object to apply out over time.
--]=]

function Animations:Transparency(animationData)
	assert(typeof(animationData.start) == "number", "Animations:Transparency requires animationData.start to be number")
	local startTransparency = animationData.start
	local endTransparency = if typeof(animationData.endpoint) == "number"
		then animationData.endpoint
		else animationData.start
	return self.clock:map(function(currentTime: number)
		local completionPercentage = math.clamp(currentTime / animationData.timeToComplete, 0, 1)
		local easedCompletionPercentage = animationData.easing(completionPercentage)
		local difference = (endTransparency - startTransparency) * easedCompletionPercentage
		local newTransparency = animationData.start + difference
		return newTransparency
	end)
end

return {
	new = new,
}
