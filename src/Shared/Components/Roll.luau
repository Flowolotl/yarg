local React = require(game:GetService("ReplicatedStorage").Packages.react)

local Corner = require(game:GetService("ReplicatedStorage").Shared.Components.Corner)

local Text = require(game:GetService("ReplicatedStorage").Shared.Scale.TextScale)
local ReactFont = require(game:GetService("ReplicatedStorage").Shared.ReactFont)

local font_size = 36

local function Roll(props: {})
	return React.createElement("Frame", {}, {}, {})
end

return Roll
