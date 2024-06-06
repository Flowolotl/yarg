local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.react)
local ReactRoblox = require(ReplicatedStorage.Packages["react-roblox"])
local Input = require(ReplicatedStorage.Packages.input)
local Keyboard = Input.Keyboard.new()

local Corner = require(ReplicatedStorage.Shared.Components.Corner)

local function ReactiveKeyboard(props)
	local text, setText = React.useState(props.Key)

	React.useEffect(function()
		Keyboard.KeyDown:Connect(function(key)
			setText(key.Name)
		end)

		Keyboard.KeyUp:Connect(function(_key)
			setText(Keyboard:GetKeysDown()[1] or "")
		end)
	end, {})

	return React.createElement("TextLabel", {
		Size = UDim2.new(0, 100, 0, 100),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(100, 164, 211),
		Text = text,
		TextScaled = true,
	}, { Corner(16) })
end

return ReactiveKeyboard