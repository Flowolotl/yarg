local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local React = require(ReplicatedStorage.Packages.react)
local ReactRoblox = require(ReplicatedStorage.Packages["react-roblox"])
local Input = require(ReplicatedStorage.Packages.input)
local Keyboard = Input.Keyboard.new()

local KeyboardComponent = require(ReplicatedStorage.Shared.Components.KeyboardComponent)
local Corner = require(ReplicatedStorage.Shared.Components.Corner)

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui


local handle = Instance.new("ScreenGui")
handle.Parent = PlayerGui

local function RollButton(props)
	local rolling, setRolling = React.useState(false)

	return React.createElement("TextButton", {
		Size = UDim2.new(0, 100, 0, 100),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(100, 164, 211),
		Text = if rolling then "Rolling..." else "Roll",
		TextScaled = true,
		Font = Enum.Font.Ubuntu,
		TextSize = 20,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		[React.Event.Activated] = function()
			if rolling then
				return
			end
			setRolling(true)
			print("Rolling")
			local coro = coroutine.create(function()

			end)

			coroutine.resume(coro)

			
		end,
	}, { Corner(16) }, {})
end

local root = ReactRoblox.createRoot(handle)

-- root:render(React.createElement(KeyboardComponent, { Key = "" }, {}))
root:render(React.createElement(RollButton, {}, {}))
