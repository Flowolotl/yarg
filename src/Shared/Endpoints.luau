
-- TODO: Add typing

type self = {
	Position: UDim2,
	Size: UDim2,
	[any]: any,
}

local Endpoints = {
	Down = function(native: self)
		return UDim2.new(native.Position.X.Scale, 0, 1, 0) + UDim2.new(0, 0, native.Size.Y.Scale, 0)
	end,
	Up = function(native: self)
		return UDim2.new(native.Pos.X.Scale, 0, 0, 0) - UDim2.new(0, 0, native.Size.Y.Scale, 0)
	end,
}

return Endpoints