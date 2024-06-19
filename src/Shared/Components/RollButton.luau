local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.react)
local ClientComm = require(ReplicatedStorage.Packages.comm).ClientComm
local Universal = require(ReplicatedStorage.Shared.Dimensions).Universal
local Animations = require(ReplicatedStorage.Shared.Animations)
type Animations = Animations.Animations

local clientComm = ClientComm.new(ReplicatedStorage)
local roll = clientComm:GetSignal("Roll")

local Corner = require(ReplicatedStorage.Shared.Components.Corner)

local Text = require(ReplicatedStorage.Shared.Scale.TextScale)
local ReactFont = require(ReplicatedStorage.Shared.ReactFont)
local useClock = require(ReplicatedStorage.Shared.Hooks.useClock)

local font_size = 36
local ce = React.createElement

type RollButtonProps = {
	Activated: () -> (),
	Deactivated: () -> (),
}

local function RollButton(props: RollButtonProps)
	local basePosition = Universal.Wrap(UDim2.new(0.5, 0, 0.85, 0))
	-- local basePosition = Universal.Wrap(UDim2.new(0.5, 0, 0.25, 0))
	local baseSize = UDim2.new(0.121, 0, 0.078, 0)

	local rolling, setRolling = React.useState(false)
	local textSize, setTextSize = React.useState(Text.TextScale(font_size))

	local clockBinding, reset = useClock()
	local animations: Animations, _ = React.useState(Animations.new(basePosition, baseSize, clockBinding) :: Animations)

	local aT = 1 -- animationTime

	React.useEffect(function()
		Text.AutoScale(setTextSize, font_size)
	end, {})

	return ce("TextButton", {
		Size = rolling and baseSize or baseSize,
		Position = rolling and animations:SlideDown(aT) or basePosition.Base,
		Transparency = rolling and animations:Transparency(aT) or 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(100, 164, 211),
		Text = if rolling then "Rolling..." else "Roll",
		FontFace = ReactFont(Enum.Font.Ubuntu, Enum.FontWeight.Bold),
		TextSize = textSize,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		[React.Event.Activated] = function(button)
			if rolling then
				return
			end
			reset()
			props.Activated()
			roll:Fire({ msg = "Hello, server!"})
			setRolling(true)
			print("Rolling")
			local coro = coroutine.create(function()
				-- TODO 1; Make new function that disables the enabled, and then re-enables them.
				-- TODO 1; This fixes issue where chat was closed for the player and after rolling it would re-open
				StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
				task.wait(3)
				StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
				props.Deactivated()
				setRolling(false)
			end)

			coroutine.resume(coro)
			coroutine.yield()
			coroutine.close(coro)
		end,
	}, { ce(Corner, { Radius = 16 }) }, {})
end

return RollButton
