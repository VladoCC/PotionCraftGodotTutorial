extends Node2D

var potion = null
var bones_map = {}

var curve1 = preload("res://Curve1.tres")
var curve2 = preload("res://Curve2.tres")
var curve3 = preload("res://Curve3.tres")

var move = false
var extend = false
var health = 100

func _ready():
	connect_areas($Potions, "potion_enter", "potion_exit")
	connect_areas($Bones, "bones_enter", "bones_exit")

func connect_areas(parent: Node, enter_func: String, exit_func: String):
	for c in parent.get_children():
		c.connect("body_entered", self, enter_func, [c])
		c.connect("body_exited", self, exit_func, [c])

func potion_enter(body, potion):
	self.potion = potion

func potion_exit(body, potion):
	self.potion = null

func bones_enter(body, bones):
	# using dictionary as set by passing any value to it
	# only thing that matters is that this key xists now in the map
	bones_map[bones] = 0

func bones_exit(body, bones):
	if bones_map.has(bones):
		bones_map.erase(bones)
	
	if bones_map.empty():
		set_health(100)

func new_curve(new: Curve2D):
	var curve = CurveUtils.split($Preview.curve, 0, $Preview.percent)
	if not curve.get_baked_points().empty():
		$Marker.set_curve(CurveUtils.append($Marker.curve, curve))
	
	$Preview.curve = Curve2D.new()
	# we add only half of the curve to preview at the begining to mathch the original
	$Preview.percent = 0.5
	var last = $Marker.curve.get_baked_points()[$Marker.curve.get_baked_points().size() - 1]
	# to correctly translate new curve to the end of the last one
	$Preview.curve.add_point(last)
	if new != null:
		$Preview.curve = CurveUtils.append($Preview.curve, new)


func _on_Curve1_pressed():
	new_curve(curve1)


func _on_Curve2_pressed():
	new_curve(curve2)


func _on_Curve3_pressed():
	new_curve(curve3)


func _on_Add_pressed():
	# adding current to marker, but without setting new curve
	new_curve(null)


func _on_Move_button_down():
	move = true


func _on_Move_button_up():
	move = false


func _on_Extend_button_down():
	extend = true


func _on_Extend_button_up():
	extend = false

func _process(delta):
	if extend:
		$Preview.percent += delta * 0.05
	
	if move and health > 0:
		$Marker/PathFollow2D.offset += delta * 50
		$Marker.hiden = $Marker/PathFollow2D.unit_offset
		
		if not bones_map.empty():
			set_health(health - delta * 20)
		
		if potion == null:
			$LevelVal.text = "-"
		else:
			var dist_vect = potion.global_position - $Marker/PathFollow2D/KinematicBody2D.global_position
			var dist_sq = dist_vect.length_squared()
			var level = 1
			if dist_sq < 25:
				level = 3
			elif dist_sq < 150:
				level = 2
			$LevelVal.text = ""
			for i in range(level):
				$LevelVal.text += "I"

func set_health(health_new):
	health = health_new
	$HealthVal.text = str(int(health))
