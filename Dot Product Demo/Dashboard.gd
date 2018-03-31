extends Panel

# Node references
onready var direction_d = get_node("VBC/GC/DirectionD")
onready var position_d = get_node("VBC/GC/PositionD")
onready var length_d = get_node("VBC/GC/LengthD")
onready var dotproduct_d = get_node("VBC/GC/DPD")
onready var angle_d = get_node("VBC/GC/AngleD")

# Tween
onready var vis_tween = Tween.new()

# Color constants
const m1 = Color(0xffffffff)
const m2 = Color(0xffffff00)

func _ready():
	# Add tween as child, then connect signal
	self.add_child(vis_tween)
	vis_tween.connect("tween_completed", self, "change_visible")

func update_panel(direction, position, length, dotproduct, angle):
	direction_d.text = "%.2f" % rad2deg(direction)
	position_d.text = "(%.2f, %.2f)" % [position.x, position.y]
	length_d.text = "%.2f" % length
	dotproduct_d.text = "%.2f" % dotproduct
	angle_d.text = "%.2f" % rad2deg(angle)
	
func toggle_visible():
	if vis_tween.is_active():
		return null
	if visible:
		vis_tween.interpolate_property(self, "modulate", m1, m2, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	else:
		visible = true
		vis_tween.interpolate_property(self, "modulate", m2, m1, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	vis_tween.start()
	
func change_visible(obj, property):
	visible = true if modulate == m1 else false
	vis_tween.stop_all()
	