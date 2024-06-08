local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local React = require(ReplicatedStorage.Packages.react)
local ReactRoblox = require(ReplicatedStorage.Packages["react-roblox"])

local RollButton = require(ReplicatedStorage.Shared.Components.RollButton)

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local function Main(_props)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
	}, { RollButton({}) }, {})
end

local handle = Instance.new("ScreenGui")
handle.Parent = PlayerGui
local root = ReactRoblox.createRoot(handle)
root:render(React.createElement(Main, {}, {}))
