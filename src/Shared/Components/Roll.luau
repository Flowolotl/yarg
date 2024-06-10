local React = require(game:GetService("ReplicatedStorage").Packages.react)

local Corner = require(game:GetService("ReplicatedStorage").Shared.Components.Corner)

local Text = require(game:GetService("ReplicatedStorage").Shared.Scale.TextScale)
local ReactFont = require(game:GetService("ReplicatedStorage").Shared.ReactFont)

local ce = React.createElement

type RollProps = {
	onClose: () -> (),
}

local function RollMain(_props: RollProps)
	return ce("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Transparency = 0.5,
	}, { ce(Corner, { Radius = 16 }) }, {})
end

return RollMain
