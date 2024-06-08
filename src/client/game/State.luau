local State = {}

State.ViewportChanged = game.Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize")

local function cur_vp()
	local cc = game.Workspace.CurrentCamera
	State.cur_vp = cc.ViewportSize
	State.ViewportChanged:Connect(function()
		State.cur_vp = game.Workspace.CurrentCamera.ViewportSize
	end)
end

cur_vp()

return State
