extends Node2D

onready var center = get_viewport_rect().size/2
onready var dp = 0
var mousepos = Vector2()
var plane_direction = Vector2(1, 0).rotated(-PI/4)
var pointer = Vector2()

const blue = Color(0.0, 0.0, 1.0)
const green = Color(0.0, 1.0, 0.0)
const red = Color(1.0, 0.0, 0.0)
const grey = Color(0.5, 0.5, 0.5)
var cur_color = green

var dashboard = null

func _ready():
	var db_s = ResourceLoader.load("res://dashboard.tscn")
	dashboard = db_s.instance()
	get_tree().get_root().call_deferred("add_child", dashboard)

func _input(event):
	if event is InputEventMouse:
		mousepos = event.position
		var left	= event.button_mask & BUTTON_LEFT != 0
		var right	= event.button_mask & BUTTON_RIGHT != 0
		var mb		= int(left) - int(right)
		if mb == 1:	# left
			plane_direction = (mousepos - center).normalized()
		elif mb == -1: # right
			center = mousepos
	elif event is InputEventKey:
		if event.scancode == KEY_H and event.is_pressed() and !event.is_echo():
			dashboard.toggle_visible()
			 
	## Computations
	pointer = mousepos - center
	dp = pointer.dot(plane_direction)
	if dp >= 0:
		cur_color = green
	else:
		cur_color = red
	update()

func _process(delta):
	if not dashboard.visible:
		return null
	dashboard.update_panel(plane_direction.angle(), pointer, pointer.length(), dp, acos(dp/pointer.length()) if pointer.length() != 0 else 1)
	
func _draw():
	# Background
	draw_rect(get_viewport_rect(), Color(1.0, 1.0, 1.0))
	# Pointer line
	draw_line(center, center + pointer, cur_color, 2.0, true)
	# Plane line
	draw_line(center, center + (plane_direction * 100), grey, 2.0, true)
	draw_line(center + (plane_direction.rotated(PI/2)*3000), center - (plane_direction.rotated(PI/2)*3000), grey, 1.0, true)
	# Projection line
	draw_functions.draw_dashed_line(self, center, center + (plane_direction * dp), 10, 10, blue, 2.0, true)
	draw_functions.draw_dashed_line(self, center + (plane_direction * dp), center + pointer, 10, 10, grey, 1.0, true)
	