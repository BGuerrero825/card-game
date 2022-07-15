extends Node2D

var hold := false
var held_card = null
signal hovered
signal unhovered

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# move thumb alongside mouse
	global_position = get_global_mouse_position()

func receive_card(card):
	self.add_child(card)
	card.position = Vector2.ZERO
	card.rotation_degrees = 0
	held_card = card
	hold = true
	
func drop_card():
	held_card.queue_free()
	hold = false

func _on_Area2D_area_entered(area):
	emit_signal("hovered", area.get_parent())

func _on_Area2D_area_exited(area):
	emit_signal("unhovered", area.get_parent())
#	if area.get_parent() == $Hand:
#		hand_hover.remove(hover.find(area.get_parent()))
#		emit_signal("hand_card_unhover", area.get_parent())
#	else:
#		hover.remove(hover.find(area.get_parent()))
