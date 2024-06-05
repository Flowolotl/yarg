local Find = {}

function Find.path(parent: Instance, path: string)
	local pathParts = path:split("/")

	local instance = parent
	for _, pathPart in ipairs(pathParts) do
		local child = instance:FindFirstChild(pathPart)
		if child == nil then
			error(`failed to find {pathPart} in {instance:GetFullName()} (full path: {path})`)
		end
		instance = child
	end
	return instance
end

return Find
