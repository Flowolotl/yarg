local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SolidModelContentProvider = game:GetService("SolidModelContentProvider")

local Animations = require(ReplicatedStorage.Shared.Animations)
local Comm = require(ReplicatedStorage.Packages.comm)
local Easings = require(ReplicatedStorage.Shared.Easings)
local Pane = require(ReplicatedStorage.Shared.Components.Pane)
local React = require(ReplicatedStorage.Packages.react)
local useClock = require(ReplicatedStorage.Shared.Hooks.useClock)

local ClientComm = Comm.ClientComm
local clientComm = ClientComm.new(ReplicatedStorage, true)
local slide = clientComm:GetSignal("Slide")

local ce = React.createElement

type TestProps = {}

function Test(props: TestProps)
	local basePos = UDim2.new(0.5, 0, 0.5, 0)
	local baseSize = UDim2.new(0.1, 0, 0.1, 0)
	local endPosition = UDim2.new(0.7, 0, 0.2, 0)

	local sliding, setSliding = React.useState(false)

	local clock, reset = useClock()
	local _animations = Animations.new(basePos, baseSize, clock)
	local animations: Animations.Animations = React.useState(_animations)

	local timeToComplete = 1

	React.useEffect(function()
		slide:Connect(function(_data)
			setSliding(not sliding)
		end)
	end, {})

	return ce(Pane, {
		native = {
			BackgroundTransparency = 0,
			Position = sliding and animations:Slide(timeToComplete, Easings.Quint.InOut, endPosition) or basePos,
			Size = baseSize,
			AnchorPoint = Vector2.new(0.5, 0.5),
		},
	})
end

return Test
