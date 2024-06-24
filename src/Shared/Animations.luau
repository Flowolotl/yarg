local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Easings = require(ReplicatedStorage.Shared.Easings)
local React = require(ReplicatedStorage.Packages.react)
local UniDim = require(ReplicatedStorage.Shared.UniDim)

type NumberReactBinding = React.Binding<number>
type UniDim = UniDim.UniDim
type Easing = Easings.Easing

export type AnimationsImpl = {
	__index: AnimationsImpl,
	new: (basePos: UDim2, baseSize: UDim2, clock: NumberReactBinding) -> Animations,
	Slide: (self: Animations, timeToComplete: number, easing: Easing, endPos: UDim2) -> React.Binding<UDim2>,
	SlideDown: (self: Animations, timeToComplete: number, easing: Easing) -> React.Binding<UDim2>,
	Transparency: (self: Animations, timeToComplete: number, easing: Easing) -> React.Binding<number>,
}

export type Animations = typeof(setmetatable(
	{} :: { basePos: UDim2, baseSize: UDim2, clock: NumberReactBinding },
	{} :: AnimationsImpl
))

local Animations = {} :: AnimationsImpl
Animations.__index = Animations

--[=[
	@class Animations
	@constructor Animations.new(basePos: UDim2, baseSize: UDim2, clock: NumberReactBinding)
	@param basePos UDim2
	@param baseSize UDim2
	@param clock NumberReactBinding
	@return Animations
	Creates a new Animations object. Used to animate GUI elements. Uses the useClock() binding to get time for animation progress.

	```lua
	local useClock = require(ReplicatedStorage.Shared.Hooks.useClock)
	local _animations: Animation = Animations.new(UDim2.new(0.5, 0, 0.5, 0), UDim2.new(0.1, 0, 0.1, 0), useClock()) :: Animations
	```
--]=]

function new(basePos: UDim2, baseSize: UDim2, clock: NumberReactBinding): Animations
	local self = setmetatable({}, Animations)
	self.basePos = basePos
	self.baseSize = baseSize
	self.clock = clock
	return self
end

--[=[
	@param endPos UDim2
	@param timeToComplete number
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

function Animations:Slide(timeToComplete, easing, endPos)
	local startPos = self.basePos
	return self.clock:map(function(currentTime: number)
		assert(typeof(endPos) == "UDim2", "End position must be a UDim2 because start position is a UDim2")
		local completionPercentage = math.clamp(currentTime / timeToComplete, 0, 1)
		local easedCompletionPercentage = easing(completionPercentage)
		local distance = (endPos - startPos)
		local displacement = UniDim.Wrap(distance):MultiplyRaw(easedCompletionPercentage) :: UDim2
		local newPos = startPos + displacement
		return newPos
	end)
end

--[=[
	@param timeToComplete number
	@param easing Easing
	@return React.Binding<UDim2>
	Creates a react binding that calculates the new position for an object to slide down the screen over time.
--]=]

function Animations:SlideDown(timeToComplete, easing)
	--TODO: this ASSUMES anchor point is (0.5, 0.5) and only works with scale.
	print("running slide down")
	local endPos = UDim2.new(self.basePos.X.Scale, 0, 1, 0) + UDim2.new(0, 0, self.baseSize.Y.Scale, 0)
	return self:Slide(timeToComplete, easing, endPos)
end

--[=[
	@param timeToComplete number
	@param easing Easing
	@return React.Binding<number>
	Creates a react binding that calculates the new transparency for an object to apply out over time.
--]=]

function Animations:Transparency(timeToComplete, easing)
	return self.clock:map(function(currentTime: number)
		return easing(math.clamp(currentTime / timeToComplete, 0, 1))
	end)
end

return {
	new = new,
}
