local function joinLists<T>(...: { T }?): { T }
	local final = nil
	local changed = false

	for _, list in { ... } do
		assert(list ~= nil, "Luau")

		if #list == 0 then
			continue
		end

		if final == nil then
			final = list
		else
			assert(final ~= nil, "Luau")

			if not changed then
				final = table.clone(final)
				changed = true
			end

			table.move(list, 1, #list, #final + 1, final)
		end
	end

	return final or {}
end

return joinLists
