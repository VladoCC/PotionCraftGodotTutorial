extends Path2D

var percent = 1 setget set_percent
func set_percent(percent_new):
	if percent_new < 0 or percent_new > 1:
		return
	percent = percent_new
	update()

func _draw():
	var points = curve.get_baked_points()
	var size = points.size()
	var part = size * percent
	var part_int = int(part)
	var part_rem = part - part_int
	
	if size == 0: 
		return
	
	var p = points[part_int] + (points[part_int + 1] - points[part_int]) * part_rem if part_int < size - 1 else points[part_int]
	
	var inc = []
	var exc = []
	for i in range(size):
		if i <= part_int:
			inc.append(points[i])
		else:
			exc.append(points[i])
	
	if not exc.empty():
		inc.append(p)
		exc.insert(0, p)
	
	draw_polyline(inc, Color.yellow, 3)
	draw_polyline(exc, Color.aqua, 3)
