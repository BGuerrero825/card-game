extends Node2D

var idle := true
var held_card = null
signal update_hover

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# move Token alongside mouse
	global_position = get_global_mouse_position()

func receive_card(card):
	self.add_child(card)
	card.position = Vector2.ZERO
	card.rotation_degrees = 0
	held_card = card
	
func drop_card():
	var dropped_card = held_card
	remove_child(held_card)
	held_card = null
	return dropped_card
	
func set_idle(val):
	idle = val
	if not idle:
		$Sprite.frame = 1
	else: 
		$Sprite.frame = 0

func _on_Area2D_area_entered(area):
	emit_signal("update_hover")
	print("area entered:", area.get_parent())

func _on_Area2D_area_exited(area):
	emit_signal("update_hover")
	print("area exited:", area.get_parent())
	
	
#	if area.get_parent() == $Hand:
#		hand_hover.remove(hover.find(area.get_parent()))
#		emit_signal("hand_card_unhover", area.get_parent())
#	else:
#		hover.remove(hover.find(area.get_parent()))
