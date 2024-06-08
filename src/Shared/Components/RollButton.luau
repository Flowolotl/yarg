local React = require(game:GetService("ReplicatedStorage").Packages.react)

local Corner = require(game:GetService("ReplicatedStorage").Shared.Components.Corner)

local Text = require(game:GetService("ReplicatedStorage").Shared.Scale.TextScale)
local ReactFont = require(game:GetService("ReplicatedStorage").Shared.ReactFont)

local font_size = 36

local function RollButton(_props: {})
	local rolling, setRolling = React.useState(false)
	local textSize, setTextSize = React.useState(Text.TextScale(font_size))

	React.useEffect(function()
		Text.AutoScale(setTextSize, font_size)
	end, {})

	return React.createElement("TextButton", {
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
			setRolling(true)
			print("Rolling")
			local coro = coroutine.create(function()
				print("a")
				task.wait(3)
				print("b")
				setRolling(false)
			end)

			coroutine.resume(coro)
			coroutine.yield()
			coroutine.close(coro)
		end,
	}, { Corner(16) }, {})
end

return RollButton
