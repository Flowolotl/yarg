-- !nonstrict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerComm = require(ReplicatedStorage.Packages.comm).ServerComm

local serverComm = ServerComm.new(ReplicatedStorage)

local signal = serverComm:CreateSignal("Roll")

Players.PlayerAdded:Connect(function(player)
	local Character = player.Character or player.CharacterAdded:Wait()
	local HumanoidRoot: Part = Character:WaitForChild("HumanoidRootPart")
	local EffectsPart: Part = ReplicatedStorage.Shared.Effects.EffectsPart:Clone()
	local Weld: WeldConstraint = Instance.new("WeldConstraint")
	EffectsPart.Parent = HumanoidRoot
	EffectsPart.CFrame = HumanoidRoot.CFrame
	Weld.Parent = HumanoidRoot
	Weld.Part0 = EffectsPart
	Weld.Part1 = HumanoidRoot
end)

signal:Connect(function(player, data)
	print("TestSignal received from", player.Name, data)
end)