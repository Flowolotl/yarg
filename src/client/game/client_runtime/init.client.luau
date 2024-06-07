local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local React = require(ReplicatedStorage.Packages.react)
local ReactRoblox = require(ReplicatedStorage.Packages["react-roblox"])

local RollButton = require(ReplicatedStorage.Shared.Components.RollButton)

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local handle = Instance.new("ScreenGui")
handle.Parent = PlayerGui

local root = ReactRoblox.createRoot(handle)

root:render(React.createElement(RollButton, {}, {}))
