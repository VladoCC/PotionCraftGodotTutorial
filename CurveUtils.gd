extends Node
class_name CurveUtils

static func append(curve1, curve2):
	if curve1 == null or curve2 == null:
		return curve1 if curve2 == null else curve2
	
	assert(curve1.get_class() == curve2.get_class(), "Parameters must be of the same type")
	var zero
	var cl
	if curve1.get_class() == "Curve2D":
		zero = Vector2.ZERO
		cl = Curve2D
	elif curve1.get_class() == "Curve3D":
		zero = Vector3.ZERO
		cl = Curve3D
	else:
		assert(false, "Parameters must by of type Curve2D or Curve3D")
	
	if curve1.get_baked_points().empty():
		curve1.add_point(zero)
	
	var trans = curve1.get_baked_points()[curve1.get_baked_points().size() - 1] - curve2.get_baked_points()[0]
	
	var result = cl.new()
	for point in curve1.get_baked_points():
		result.add_point(point)
	
	for point in curve2.get_baked_points():
		result.add_point(point + trans)
	
	return result

static func split(curve: Curve2D, start: float, end: float) -> Curve2D:
	assert(start >= 0 and start < end, "Start must be in range [0, end)")
	assert(end <=  1, "End must be in range (start, 1]")
	
	var result
	print(curve.get_class())
	if curve.get_class() == "Curve2D":
		result = Curve2D.new()
	elif curve.get_class() == "Curve3D":
		result = Curve3D.new()
	else:
		assert(false, "Parameters must by of type Curve2D or Curve3D")
	print(result, " ", result.get_class())
	
	var points = curve.get_baked_points()
	var size = points.size()
	
	var start_point = size * start
	var start_int = int(start_point)
	var start_rem = start_point - start_int
	
	var end_point = size * end
	var end_int = int(end_point)
	var end_rem = end_point - end_int
	
	if start_rem > 0 and start_int < size - 1:
		var p = points[start_int] + (points[start_int + 1] - points[start_int]) * start_rem
		result.add_point(p)
	
	for i in range(size):
		if i > start_int and i <= end_int:
			result.add_point(points[i])
	
	if end_rem > 0 and end_int < size - 1:
		var p = points[end_int] + (points[end_int + 1] - points[end_int]) * end_rem
		result.add_point(p)
	
	return result
