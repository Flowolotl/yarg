export type UniDim = {
    Base: UDim2 | UDim,
    Multiply: (base: UDim2 | UDim, multiplier: number) -> UDim2 | UDim,
    MultiplyRaw: (base: UDim2 | UDim, multiplier: number) -> UDim2 | UDim,
    Cross: (base: UDim2 | UDim, factor: UDim2 | UniDim) -> UDim2 | UDim,
    CrossRaw: (base: UDim2 | UDim, factor: UDim2 | UniDim) -> UDim2 | UDim,
}

type Op = (val: number, factor: number) -> number

local function _op(self: UniDim, factor: UDim2 | UDim | number, op: Op): UDim2 | UDim
    if typeof(self.Base) == "UDim2" then
        local Base: UDim2 = self.Base
        if typeof(factor) == "number" then
            return UDim2.new(op(Base.X.Scale, factor), op(Base.X.Offset, factor), op(Base.Y.Scale, factor), op(Base.Y.Offset, factor))
        elseif typeof(factor) == "UDim2" then
            return UDim2.new(op(Base.X.Scale, factor.X.Scale), op(Base.X.Offset, factor.X.Offset), op(Base.Y.Scale, factor.Y.Scale), op(Base.Y.Offset, factor.Y.Offset))
        end
    elseif typeof(self.Base) == "UDim" then
        local Base: UDim = self.Base
        if typeof(factor) == "number" then
            return UDim.new(op(Base.Scale, factor), op(Base.Offset, factor))
        elseif typeof(factor) == "UDim" then
            return UDim.new(op(Base.Scale, factor.Scale), op(Base.Offset, factor.Offset))
        end
    end
end

local UniDim = {}
UniDim.__index = UniDim

function UniDim.Wrap(base: UDim2 | UDim): UniDim
    local self = setmetatable({}, UniDim)
    self.Base = base
    return self
end

function UniDim:Multiply(factor: number): UniDim
    self.Base = _op(self, factor, function(val: number, iFactor: number): number
        return val * iFactor
    end)
    return self
end

function UniDim:MultiplyRaw(factor: number): UniDim
    return _op(self, factor, function(val: number, iFactor: number): number
        return val * iFactor
    end)
end

function UniDim:Cross(udimFactor: UDim2 | UniDim): UniDim
    assert(typeof(udimFactor) == typeof(self.Base), "Cannot cross UDim2 with UDim")
    self.Base = _op(self, udimFactor, function(val: number, iFactor: number): number
        return val * iFactor
    end)
    return self
end

function UniDim:CrossRaw(udimFactor: UDim2 | UniDim): UniDim
    assert(typeof(udimFactor) == typeof(self.Base), "Cannot cross UDim2 with UDim")
    return _op(self, udimFactor, function(val: number, iFactor: number): number
        return val * iFactor
    end)
end

return {
    Universal = {
        Wrap = UniDim.Wrap
    }
}