extends Node2D

var hold := false
var held_card = null
var overlap := []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# move thumb alongside mouse
	global_position = get_global_mouse_position()

func check_overlap():
	pass

func grab_card(card):
	self.add_child(card)
	card.position = Vector2.ZERO
	card.rotation_degrees = 0
	held_card = card
	hold = true
	
func drop_card():
	held_card.queue_free()
	hold = false


func _on_Area2D_area_entered(area):
	overlap.append(area.get_parent())
	print(overlap)


func _on_Area2D_area_exited(area):
	overlap.remove(overlap.find(area.get_parent()))
	print(overlap)
