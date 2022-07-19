extends Node2D

# hand spacing and initialization variables
var cards = []
var focused = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# HELPER FUNCTIONS -------------------------------------

# aligns cards in hand based on amount
func position_cards():
	#scale offset ranges logarithmically with hand size
	var hand_width = 60 * log(cards.size())
	var hand_height = 4 * log(cards.size())
	var rot_range = 30 * log(cards.size())
	# if hand is one card, set transform to zero
	if cards.size() == 1:
		cards[0].position = Vector2(0,0)
		cards[0].rotation_degrees = 0
	#if hand is greater than one, set x and y offsets and rotation angle of cards based on position in hand
	elif(cards.size() > 1):
		for i in range(0,cards.size()):
			cards[i].position.x = (-hand_width / 2) + ((hand_width / (cards.size()-1)) * i)
			cards[i].position.y =  pow((hand_height / 2) - ((hand_height / (cards.size()-1)) * i),2)
			cards[i].rotation_degrees = (-rot_range / 2) + ((rot_range / (cards.size()-1)) * i)
			move_child(cards[i], i+1)

# set a new focused card, unfocusing the previous one and enlarging sprite
func set_focus(index = null):
	# unfocus previous focused
	if focused != null:
		var sprite = cards[focused].get_node("Sprite")
		sprite.scale = Vector2(1.0,1.0)
		sprite.z_index = 0
		sprite.position.y = 0
		sprite.rotation_degrees = 0
		focused = null
	# set new focus
	if index != null:
		focused = index
		var sprite = cards[index].get_node("Sprite")
		sprite.scale = Vector2(1.4,1.4)
		sprite.z_index = 1
		sprite.position.y = -30
		# comment out next line for card tilt on focus
		sprite.rotation_degrees = -cards[index].rotation_degrees


# CALL FUNCTIONS -------------------------------------

# add card to hand to a specified index, or end of hand
func receive_card(card, index = null):
	if index != null:
		cards.insert(index+1, card)
	else:
		cards.append(card)
	add_child(card)
	position_cards()

# return and remove currently focused card
func send_focused_card():
	var card = cards[focused]
	# remove card from hand
	set_focus()
	cards.erase(card)
	remove_child(card)
	#reposition cards 
	position_cards()
	return card

# determine which card should be focused by highest index card hovered by token
func determine_focus(hover):
	var highest_index = null
	for card in hover:
		var index = cards.find(card)
		if highest_index == null or index > highest_index:
			highest_index = index
	set_focus(highest_index)


# SIGNAL FUNCTIONS -------------------------------------



