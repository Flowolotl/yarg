local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.react)
local join = require(ReplicatedStorage.Shared.join)

local ce = React.createElement

type PaneProps = {
	native: { [any]: any }?,
	children: React.ReactNode,
}

function Pane(props: PaneProps)
	return ce(
		"Frame",
		join({
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
		}, props.native),
		props.children
	)
end

return Pane
