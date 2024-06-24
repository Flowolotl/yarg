export type Easings = {
	Circ: { In: Easing, Out: Easing, InOut: Easing },
	Quint: { In: Easing, Out: Easing, InOut: Easing },
	Quart: { In: Easing, Out: Easing, InOut: Easing },
	Cubic: { In: Easing, Out: Easing, InOut: Easing },
	Quad: { In: Easing, Out: Easing, InOut: Easing },
	Sine: { In: Easing, Out: Easing, InOut: Easing },
	In: {
		Circ: Easing,
		Quint: Easing,
		Quart: Easing,
		Cubic: Easing,
		Quad: Easing,
		Sine: Easing,
	},
	Out: {
		Circ: Easing,
		Quint: Easing,
		Quart: Easing,
		Cubic: Easing,
		Quad: Easing,
		Sine: Easing,
	},
	InOut: {
		Circ: Easing,
		Quint: Easing,
		Quart: Easing,
		Cubic: Easing,
		Quad: Easing,
		Sine: Easing,
	},
}

export type Easing = (x: number) -> number
type EasingTable = { In: Easing, Out: Easing, InOut: Easing }

local Easings = {
	Circ = {} :: EasingTable,
	Quint = {} :: EasingTable,
	Quart = {} :: EasingTable,
	Cubic = {} :: EasingTable,
	Quad = {} :: EasingTable,
	Sine = {} :: EasingTable,
}

-- Circle
function Easings.Circ.In(x)
	return 1 - math.sqrt(1 - x * x)
end

function Easings.Circ.Out(x)
	return math.sqrt(1 - math.pow(x - 1, 2))
end

function Easings.Circ.InOut(x)
	return x < 0.5 and (1 - math.sqrt(1 - math.pow(2 * x, 2))) / 2 or (math.sqrt(1 - math.pow(-2 * x + 2, 2)) + 1) / 2
end

-- Quintic
function Easings.Quint.In(x)
	return math.pow(x, 5)
end

function Easings.Quint.Out(x)
	return 1 - math.pow(1 - x, 5)
end

function Easings.Quint.InOut(x)
	return x < 0.5 and 16 * x * x * x * x * x or 1 - math.pow(-2 * x + 2, 5) / 2
end

-- Quartic
function Easings.Quart.In(x)
	return math.pow(x, 4)
end

function Easings.Quart.Out(x)
	return 1 - math.pow(1 - x, 4)
end

function Easings.Quart.InOut(x)
	return x < 0.5 and 8 * x * x * x * x or 1 - math.pow(-2 * x + 2, 4) / 2
end

-- Cubic
function Easings.Cubic.In(x)
	return math.pow(x, 3)
end

function Easings.Cubic.Out(x)
	return 1 - math.pow(1 - x, 3)
end

function Easings.Cubic.InOut(x)
	return x < 0.5 and 4 * x * x * x or 1 - math.pow(-2 * x + 2, 3) / 2
end

-- Quadratic
function Easings.Quad.In(x)
	return x * x
end

function Easings.Quad.Out(x)
	return 1 - math.pow(1 - x, 2)
end

function Easings.Quad.InOut(x)
	return x < 0.5 and 2 * x * x or 1 - math.pow(-2 * x + 2, 2) / 2
end

-- Sine
function Easings.Sine.In(x)
	return 1 - math.cos(x * math.pi / 2)
end

function Easings.Sine.Out(x)
	return math.sin(x * math.pi / 2)
end

function Easings.Sine.InOut(x)
	return -(math.cos(math.pi * x) + 1) / 2
end

return Easings
