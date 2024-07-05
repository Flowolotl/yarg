type self = {
    length: number,
    length2: number?,
    shared: { any }?
}

function GetTableData(table1: {}, table2: {}?): self
    local data = {} :: self
    data.length = 0
    data.length2 = if table2 then 0 else nil
    data.shared = if table2 then {} else nil

	for k, _ in pairs(table1) do
		data.length += 1
        if table2 and typeof(data.shared) == "table" then
            if table2[k] then
                data.shared[k] = table2[k] -- should set to table2 because will be used for target table in Animations
            end
        end
	end

    if data.length2 and table2 then
        for _, _ in pairs(table2) do
            data.length2 += 1
        end
    end

    return data
end

return GetTableData