extends Node2D

var active_turn := true
var hover := []
var hand_hover := []
var table
signal to_table
signal to_object
signal from_object

# Called when the node enters the scene tree for the first time.
func _ready():
	# make mouse invisible
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	table = get_tree().get_root().get_node("Table")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	input_handling()
	

# HELPER FUNCTIONS -------------------------------------

# flow control of inputs made by human controlling this player
func input_handling():
	if not active_turn:
		return
	# on left click, Token press
	if Input.is_action_just_pressed("left_click") and $Token.idle:
		token_press()
	# on left click release, Token release
	elif Input.is_action_just_released("left_click"):
		token_release()

# all actions originated from the press of the player token
func token_press():
	$Token.set_idle(false)
	# if a card in the hand is focused, add it to Token and remove from hand
	if $Hand.focused != null:
		hand_to_token()
	# if objects are hovered by the token, grab the most recent one
	elif hover:
		print(hover[0])
		var source = hover[0]
		emit_signal("from_object", source, self)

# all actions originated from the release of the player token
func token_release():
	# if a card in the Token, remove it then move it based on the recipient
	if $Token.held_card:
		var card = $Token.drop_card()
		# if hovering over the player's hand
		if hover.has($Hand):
			# if hovering over a card in the hand, place this card after the most recently hovered
			if hand_hover:
				var index = $Hand.cards.find(hand_hover[0])
				$Hand.receive_card(card, index)
			# else place it at the end
			else:
				$Hand.receive_card(card)
		# if token not hovering anything controlled by the player
		else:
			# if hovering any other object
			if hover:
				$Outbound.add_child(card)
				var target = hover[0]
				print(hover)
				emit_signal("to_object", card, target)
			# if hovering nothing
			else:
				$Outbound.add_child(card)
				var pos = get_global_mouse_position()
				emit_signal("to_table", card, pos)
				
			
			
	# do nothing if no item in Token
	# reset Token to idle state
	$Token.set_idle(true)

# transfer the focused card to the player token
func hand_to_token():
	var card = $Hand.send_focused_card()
	$Token.receive_card(card)

# CALL FUNCTIONS -------------------------------------

func receive_card(card):
	# should check to see if Token is requesting, else goes to hand
	###
	# to hand
	$Hand.receive_card(card)


# SIGNAL FUNCTIONS -------------------------------------

func _on_Token_hovered(object):
	if object.get_parent() == $Hand:
		hand_hover.push_front(object)
		if $Token.idle:
			$Hand.determine_focus(hand_hover)
	# do not include cards in hover (they always belong to a parent node)
	elif not "Card" in object.name and not "Hand" in object.name:
		hover.push_front(object)
	print(hover)
		

func _on_Token_unhovered(object):
	if object.get_parent() == $Hand:
		hand_hover.erase(object)
		if $Token.idle:
			$Hand.determine_focus(hand_hover)
	else:
		if hover.has(object):
			hover.erase(object)
	print(hover)
