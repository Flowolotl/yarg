return function(family: Enum.Font, weight: Enum.FontWeight, style: Enum.FontStyle?): Font
	return Font.new(Font.fromEnum(family).Family, weight, style or Enum.FontStyle.Normal)
end
