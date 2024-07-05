local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local Animations = require(ReplicatedStorage.Shared.Animations)
local Comm = require(ReplicatedStorage.Packages.comm)
local Corner = require(ReplicatedStorage.Shared.Components.Corner)
local Easings = require(ReplicatedStorage.Shared.Easings)
local HideEnabledCoreGui = require(ReplicatedStorage.Shared.HideEnabledCoreGui)
local React = require(ReplicatedStorage.Packages.react)
local ReactFont = require(ReplicatedStorage.Shared.ReactFont)
local Text = require(ReplicatedStorage.Shared.Scale.TextScale)
local Trove = require(ReplicatedStorage.Packages.trove)
local Endpoints = require(ReplicatedStorage.Shared.Endpoints)
local useClock = require(ReplicatedStorage.Shared.Hooks.useClock)

local ClientComm = Comm.ClientComm

local clientComm = ClientComm.new(ReplicatedStorage, true)
local roll = clientComm:GetSignal("Roll")

local font_size = 36
local ce = React.createElement

type RollButtonProps = {
	Activated: () -> (),
	Deactivated: () -> (),
}

local function RollButton(props: RollButtonProps)
	local native = {
		Position = UDim2.new(0.5, 0, 0.85, 0),
		Size = UDim2.new(0.121, 0, 0.078, 0),
		Transparency = 0,
	}

	local rolling, setRolling = React.useState(false)
	local textSize, setTextSize = React.useState(Text.TextScale(font_size))

	local clockBinding, resetClock = useClock()
	local positionAnimation = React.useState(Animations.new(clockBinding, native, Endpoints.Down(native), "Position") :: Animations.Animations<UDim2>)
	local transparencyAnimation = React.useState(Animations.new(clockBinding, native, 1, "Transparency") :: Animations.Animations<number>)

	local aT = 1 -- animationTime	

	React.useEffect(function()
		Text.AutoScale(setTextSize, font_size)
	end, {})

	return ce("TextButton", {
		Size = native.Size,
		Position = rolling and positionAnimation:Forward(Easings.Quint.InOut, aT) or positionAnimation:Reverse(Easings.Quint.InOut, aT),
		Transparency = rolling and transparencyAnimation:Forward(Easings.Quint.InOut, aT) or transparencyAnimation:Reverse(Easings.Quint.InOut, aT),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(100, 164, 211),
		Text = if rolling then "Rolling..." else "Roll",
		FontFace = ReactFont(Enum.Font.Ubuntu, Enum.FontWeight.Bold),
		TextSize = textSize,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		[React.Event.Activated] = function()
			if rolling then
				return
			end
			resetClock()
			props.Activated()
			roll:Fire({ msg = "Hello, server!" })
			setRolling(true)

			local coro = coroutine.create(function()
				local show = HideEnabledCoreGui()
				task.wait(3)
				show()
				setRolling(false)
				props.Deactivated()
				task.wait() -- necessary because setRolling will take one frame to update.
				resetClock()
				coroutine.yield()
			end)
			coroutine.resume(coro)
		end,
	}, { ce(Corner, { Radius = 16 }) }, {})
end

return RollButton
