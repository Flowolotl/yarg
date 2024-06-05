local function Map(t, func)
    for k, v in pairs(t) do
        local f = func(v)
        t[k] = f
    end
    return t
end

return Map