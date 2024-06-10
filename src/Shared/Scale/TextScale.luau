local State = require(game:GetService("StarterPlayer").StarterPlayerScripts.Game.State)

local Scale = require(script.Parent)

local function TextScale(text_size: number)
	local scale, cur_vp = Scale()
	if cur_vp.X == 1 and cur_vp.Y == 1 then
		print("bad viewport")
		return text_size
	end
	print("changing text size:" .. text_size * scale.Y)
	return text_size * scale.Y
end

local function _test(setTest, font_size: number)
	State.ViewportChanged:Connect(function()
		setTest(TextScale(font_size))
	end)
end

return {
	TextScale = TextScale,
	AutoScale = _test,
}
