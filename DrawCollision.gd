extends CollisionPolygon2D

export(Color) var color = Color.white

func _draw():
	draw_colored_polygon(polygon, color)
