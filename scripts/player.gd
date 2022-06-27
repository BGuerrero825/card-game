extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#make mouse invisible
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	input_handling()
	
# flow control of inputs made by human controlling this player
func input_handling():
	if Input.is_action_just_pressed("left_click"):
		$Thumb/Sprite.frame = 1
		# if a card in the hand is focused (hovered), add it to thumb and remove from hand
		if $Hand.focused != null:
			hand_to_thumb()
	if Input.is_action_just_released("left_click"):
		$Thumb/Sprite.frame = 0
		# if a card in the thumb, drop it
		if $Thumb.hold:
			$Thumb.drop_card()

func hand_to_thumb():
	var card = $Hand.get_focused_card()
	$Thumb.grab_card(card)
	$Hand.remove_card(card.index)
	
func receive_card(card, from):
	#should check to see if thumb is requesting, else goes to hand
	
	# to hand
	$Hand.receive_card(card)
