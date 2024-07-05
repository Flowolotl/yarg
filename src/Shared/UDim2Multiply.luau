function UDim2Multiply(udim2: UDim2, multiplier: number): UDim2
    return UDim2.new(
        udim2.X.Scale * multiplier,
        udim2.X.Offset * multiplier,
        udim2.Y.Scale * multiplier,
        udim2.Y.Offset * multiplier
    )
end

return UDim2Multiply