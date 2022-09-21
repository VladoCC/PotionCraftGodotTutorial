extends Path2D

var hiden = 0 setget set_hiden
func set_hiden(hiden_new):
	if hiden_new > 1 or hiden_new < 0:
		return
	
	hiden = hiden_new
	update()

func _ready():
	if curve.get_baked_points().empty():
		curve.add_point(Vector2.ZERO)

# this function is required for forcing redraws
func set_curve(curve_new: Curve2D):
	curve = curve_new
	# making sure to cirrectly show hat part of the curve is left afterany updates
	set_hiden($PathFollow2D.unit_offset)
	update()

func _draw():
	var points = curve.get_baked_points()
	var size = points.size()
	var ind = int(size * hiden)
	var rem = size * hiden - ind
	var draw = []
	if ind < size - 1:
		draw.append(points[ind] + (points[ind + 1] - points[ind]) * rem)
	for i in range(ind+ 1, size):
		draw.append(points[i])
	draw_polyline(draw, Color.green, 3)
