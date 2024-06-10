local StarterGui = game:GetService("StarterGui")
local React = require(game:GetService("ReplicatedStorage").Packages.react)

local Corner = require(game:GetService("ReplicatedStorage").Shared.Components.Corner)

local Text = require(game:GetService("ReplicatedStorage").Shared.Scale.TextScale)
local ReactFont = require(game:GetService("ReplicatedStorage").Shared.ReactFont)

local font_size = 36
local ce = React.createElement

type RollButtonProps = {
	Activated: () -> (),
	Deactivated: () -> (),
}

local function RollButton(props: RollButtonProps)
	local rolling, setRolling = React.useState(false)
	local textSize, setTextSize = React.useState(Text.TextScale(font_size))

	React.useEffect(function()
		Text.AutoScale(setTextSize, font_size)
	end, {})

	return ce("TextButton", {
		Size = UDim2.new(0.121, 0, 0.078, 0),
		Position = UDim2.new(0.5, 0, 0.85, 0),
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
			props.Activated()
			setRolling(true)
			print("Rolling")
			local coro = coroutine.create(function()
				-- TODO 1; Animate button slides down off screen and fade out
				-- TODO 2; Make new function that disables the enabled, and then re-enables them.
				-- TODO 2; This fixes issue where chat was closed for the player and after rolling it would re-open
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
