local f = table.freeze

-- Circle
function easeInCirc(x)
    return 1 - math.sqrt(1 - x * x)
end

function easeOutCirc(x)
    return math.sqrt(1 - math.pow(x - 1, 2))
end

function easeInOutCirc(x)
    return x < 0.5 and (1 - math.sqrt(1 - math.pow(2 * x, 2))) / 2 or (math.sqrt(1 - math.pow(-2 * x + 2, 2)) + 1) / 2
end

-- Quintic
function easeInOutQuint(x)
    return x < 0.5 and 16 * x * x * x * x * x or 1 - math.pow(-2 * x + 2, 5) / 2
end

function easeInQuint(x)
    return math.pow(x, 5)
end

function easeOutQuint(x)
    return 1 - math.pow(1 - x, 5)
end

-- Quartic
function easeInOutQuart(x)
    return x < 0.5 and 8 * x * x * x * x or 1 - math.pow(-2 * x + 2, 4) / 2
end

function easeInQuart(x)
    return math.pow(x, 4)
end

function easeOutQuart(x)
    return 1 - math.pow(1 - x, 4)
end

-- Cubic
function easeInOutCubic(x)
    return x < 0.5 and 4 * x * x * x or 1 - math.pow(-2 * x + 2, 3) / 2
end

function easeInCubic(x)
    return math.pow(x, 3)
end

function easeOutCubic(x)
    return 1 - math.pow(1 - x, 3)
end

-- Quadratic
function easeInOutQuad(x)
    return x < 0.5 and 2 * x * x or 1 - math.pow(-2 * x + 2, 2) / 2
end

function easeInQuad(x)
    return x * x
end

function easeOutQuad(x)
    return 1 - math.pow(1 - x, 2)
end

-- Sine
function easeInOutSine(x)
    return -(math.cos(math.pi * x) + 1) / 2
end

function easeInSine(x)
    return 1 - math.cos(x * math.pi / 2)
end

function easeOutSine(x)
    return math.sin(x * math.pi / 2)
end


return f{
    Circ = f{
        In = easeInCirc,
        Out = easeOutCirc,
        InOut = easeInOutCirc,
    },
    Quint = f{
        In = easeInQuint,
        Out = easeOutQuint,
        InOut = easeInOutQuint,
    },
    Quart = f{
        In = easeInQuart,
        Out = easeOutQuart,
        InOut = easeInOutQuart,
    },
    Cubic = f{
        In = easeInCubic,
        Out = easeOutCubic,
        InOut = easeInOutCubic,
    },
    Quad = f{
        In = easeInQuad,
        Out = easeOutQuad,
        InOut = easeInOutQuad,
    },
    Sine = f{
        In = easeInSine,
        Out = easeOutSine,
        InOut = easeInOutSine,
    },

    In = f{
        Circ = easeInCirc,
        Quint = easeInQuint,
        Quart = easeInQuart,
        Cubic = easeInCubic,
        Quad = easeInQuad,
        Sine = easeInSine,
    },
    Out = f{
        Circ = easeOutCirc,
        Quint = easeOutQuint,
        Quart = easeOutQuart,
        Cubic = easeOutCubic,
        Quad = easeOutQuad,
        Sine = easeOutSine,
    },
    InOut = f{
        Circ = easeInOutCirc,
        Quint = easeInOutQuint,
        Quart = easeInOutQuart,
        Cubic = easeInOutCubic,
        Quad = easeInOutQuad,
        Sine = easeInOutSine,
    },
}