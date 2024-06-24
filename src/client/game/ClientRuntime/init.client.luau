local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.react)
local ReactRoblox = require(ReplicatedStorage.Packages["react-roblox"])
local Roll = require(ReplicatedStorage.Shared.Components.Roll)
local RollButton = require(ReplicatedStorage.Shared.Components.RollButton)
local useToggleState = require(game:GetService("ReplicatedStorage").Shared.Hooks.useToggleState)

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local ce = React.createElement

local function Main(_props)
	local rollState = useToggleState(false)

	return ce("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
	}, {
		RollPage = rollState.on and ce(Roll, {
			onClose = rollState.disable,
		}),

		RollButton = ce(RollButton, {
			Activated = rollState.enable,
			Deactivated = rollState.disable,
		}),
	}, {})
end

local handle = Instance.new("ScreenGui")
handle.Parent = PlayerGui
handle.IgnoreGuiInset = true
local root = ReactRoblox.createRoot(handle)
root:render(ce(Main, {}, {}))
