extends Node2D

# 2 digits: (h|c|d|s) + (2-9|t|j|q|k|a) | (b1|b2|j1|j2)
export var type := "b1"
var hovered := false
var index := -1
signal clicked(type)
signal hovered(index)
signal unhovered(index)

# Called when the node enters the scene tree for the first time.
func _ready():
	set_type(type)
	# flip_up()

func set_type(type):
	#if an improper type given, default to background 2
	if type.length() < 2:
		$Sprite.frame = 53
		return
	#default card frame to background 2
	var frame = 53
	#set card frame based on suite
	if type[0] == 'h': frame = 0
	elif type[0] == 'c': frame = 13
	elif type[0] == 'd': frame = 26
	elif type[0] == 's': frame = 39
	#if card matched a suite, add on its value
	if frame != 53: 
		frame += int(type[1]) - 2
		if type[1] == 't': frame += 10
		elif type[1] == 'j': frame += 11
		elif type[1] == 'q': frame += 12
		elif type[1] == 'k': frame += 13
		elif type[1] == 'a': frame += 14
	#resolve special card types if no suite matched
	else:
		if type == "b1": frame = 52
		elif type == "b2": frame = 53
		elif type == "j1": frame = 54
		elif type == "j2": frame = 55
	#assign calculated frame to sprite
	$Sprite.frame = frame
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func flip_down():
	pass
	
func flip_up():
	pass

#enlarge and align Sprite 
func select():
	$Sprite.scale = Vector2(1.4,1.4)
	$Sprite.z_index = 1
	$Sprite.position.y = -30
	$Sprite.rotation_degrees = -rotation_degrees
	
#return Sprite to original transform
func deselect():
	$Sprite.scale = Vector2(1.0,1.0)
	$Sprite.z_index = 0
	$Sprite.position.y = 0
	$Sprite.rotation_degrees = 0

func _on_Area2D_mouse_entered():
	hovered = true
	emit_signal("hovered", index)
	
func _on_Area2D_mouse_exited():
	hovered = false
	emit_signal("unhovered", index)
