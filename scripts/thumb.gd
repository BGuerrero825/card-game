extends Node2D

var hold := false
var card = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# move thumb alongside mouse
	global_position = get_global_mouse_position()
	
func grab_card(old_card):
	card = AssetLoader.CARD.instance()
	self.add_child(card)
	hold = true
	
func drop_card():
	card.queue_free()
	hold = false
