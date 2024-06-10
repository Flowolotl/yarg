local function Scale()
	local cur_vp = game.Workspace.CurrentCamera.ViewportSize
	return Vector2.new(cur_vp.X / 2000, cur_vp.Y / 1125), cur_vp
end

return Scale
