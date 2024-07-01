local StarterGui = game:GetService("StarterGui")

function HideEnabledCoreGui()
	local coreGuis = {
		Enum.CoreGuiType.Backpack,
		Enum.CoreGuiType.Captures,
		Enum.CoreGuiType.Chat,
		Enum.CoreGuiType.EmotesMenu,
		Enum.CoreGuiType.Health,
		Enum.CoreGuiType.PlayerList,
	}
	local enabledCoreGuis = {}
	for _, coreGui in pairs(coreGuis) do
		local enabled = StarterGui:GetCoreGuiEnabled(coreGui)
		if enabled then
			table.insert(enabledCoreGuis, coreGui)
			StarterGui:SetCoreGuiEnabled(coreGui, false)
		end
	end
	return function()
		for _, coreGui in pairs(enabledCoreGuis) do
			StarterGui:SetCoreGuiEnabled(coreGui, true)
		end
	end
end

return HideEnabledCoreGui
