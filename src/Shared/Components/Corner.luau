local React = require(game:GetService("ReplicatedStorage").Packages.react)

return function(_radius)
	return React.createElement("UICorner", {
		CornerRadius = UDim.new(0, _radius or 30),
	})
end
