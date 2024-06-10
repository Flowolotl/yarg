local React = require(game:GetService("ReplicatedStorage").Packages.react)

type CornerProps = {
	Radius: number?,
}

return function(props: CornerProps)
	return React.createElement("UICorner", {
		CornerRadius = UDim.new(0, props.Radius or 30),
	})
end
