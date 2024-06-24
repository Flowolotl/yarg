export type UniDimImpl = {
	__index: UniDimImpl,
	Wrap: (base: UDim2 | UDim) -> UniDim,
	Multiply: (self: UniDim, multiplier: number) -> UniDim,
	MultiplyRaw: (self: UniDim, multiplier: number) -> UDim2 | UDim,
	Cross: (self: UniDim, factor: UDim2 | UDim) -> UniDim,
	CrossRaw: (self: UniDim, factor: UDim2 | UDim) -> UDim2 | UDim,
}

export type UniDim = typeof(setmetatable({} :: { Base: UDim | UDim2 }, {} :: UniDimImpl))

type Op = (val: number, factor: number) -> number

local UniDim: UniDimImpl = {} :: UniDimImpl
UniDim.__index = UniDim

local function _op(self: UniDim, factor: UDim2 | UDim | number, op: Op): UDim2 | UDim | never
	if typeof(self.Base) == "UDim2" then
		local Base = self.Base
		if typeof(factor) == "number" then
			return UDim2.new(
				op(Base.X.Scale, factor),
				op(Base.X.Offset, factor),
				op(Base.Y.Scale, factor),
				op(Base.Y.Offset, factor)
			)
		elseif typeof(factor) == "UDim2" then
			return UDim2.new(
				op(Base.X.Scale, factor.X.Scale),
				op(Base.X.Offset, factor.X.Offset),
				op(Base.Y.Scale, factor.Y.Scale),
				op(Base.Y.Offset, factor.Y.Offset)
			)
		end
	elseif typeof(self.Base) == "UDim" then
		local Base = self.Base
		if typeof(factor) == "number" then
			return UDim.new(op(Base.Scale, factor), op(Base.Offset, factor))
		elseif typeof(factor) == "UDim" then
			return UDim.new(op(Base.Scale, factor.Scale), op(Base.Offset, factor.Offset))
		end
	end
	return nil :: never
end

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

function UniDim:MultiplyRaw(factor: number): UDim2 | UDim
	return _op(self, factor, function(val: number, iFactor: number): number
		return val * iFactor
	end)
end

function UniDim:Cross(udimFactor: UDim2 | UDim): UniDim
	assert(typeof(udimFactor) == typeof(self.Base), "Cannot cross UDim2 with UDim")
	self.Base = _op(self, udimFactor, function(val: number, iFactor: number): number
		return val * iFactor
	end)
	return self
end

function UniDim:CrossRaw(udimFactor: UDim2 | UDim): UDim2 | UDim
	assert(typeof(udimFactor) == typeof(self.Base), "Cannot cross UDim2 with UDim")
	return _op(self, udimFactor, function(val: number, iFactor: number): number
		return val * iFactor
	end)
end

return UniDim
