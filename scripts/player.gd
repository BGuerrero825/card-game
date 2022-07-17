extends Node2D

var active_turn := true
var hover := []
var hand_hover := []
var token_update_request := false
var frame = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	# make mouse invisible
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	input_handling()
	
# flow control of inputs made by human controlling this player
func input_handling():
	if not active_turn:
		return
	# on left click, Token press
	if Input.is_action_just_pressed("left_click") and $Token.idle:
		$Token.set_idle(false)
		# if a card in the hand is focused, add it to Token and remove from hand
		if $Hand.focused != null:
			hand_to_token()
	# on left click release, Token unpress
	elif Input.is_action_just_released("left_click"):
		# if a card in the Token, drop it
		if $Token.held_card:
			var card = $Token.drop_card()
			# if hovering over the player's hand
			if hover.has($Hand):
				# if hovering over a card in the hand
				if hand_hover:
					var index = $Hand.cards.find(hand_hover[0])
					$Hand.receive_card(card, index)
				else:
					$Hand.receive_card(card)
		$Token.set_idle(true)

func hand_to_token():
	var card = $Hand.send_focused_card()
	$Token.receive_card(card)
	
func receive_card(card):
	# should check to see if Token is requesting, else goes to hand
	###
	# to hand
	$Hand.receive_card(card)

func update_hover():
	var all_hovers = $Token/Area2D.get_overlapping_areas()
	hover = []
	hand_hover = []
	for area in all_hovers:
		var object = area.get_parent()
		if object.get_parent() == $Hand:
			hand_hover.push_front(object)
		else:
			hover.push_front(object)
	if $Token.idle:
		$Hand.determine_focus(hand_hover)
	print("Hand hovers: ", hand_hover)
	print("Object hovers: ", hover)

		
#func _on_Token_hovered(object):
#	if object.get_parent() == $Hand:
#		hand_hover.push_front(object)
#		print("hand: ", hand_hover)
#		if $Token.idle:
#			$Hand.call_deferred("determine_focus", hand_hover)
#	else:
#		hover.push_front(object)
#		print("objects: ", hover)
#
#func _on_Token_unhovered(object):
#	if object.get_parent() == $Hand:
#		hand_hover.erase(object)
#		print("hand: ", hand_hover)
#		if $Token.idle:
#			$Hand.call_deferred("determine_focus", hand_hover)
#	else:
#		hover.erase(object)
#		print("objects: ", hover)

