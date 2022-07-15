extends Node2D

# hand spacing and initialization variables
var cards = []
var focused = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
#func _process(delta):
	#pass

# add card to the end of the hand and attach signals
func receive_card(card):
	cards.append(card)
	self.add_child(card)
	position_cards()

# return and disconnect currently focused card
func send_focused_card():
	var card = cards[focused]
	# remove card from hand
	cards[focused].unfocus()
	focused = null
	cards.erase(card)
	remove_child(card)
	#reposition cards 
	position_cards()
	return card

# set focus on highest index hovered card
func focus_hover(hover):
	var highest_index = -1
	for card in hover:
		var index = cards.find(card)
		if index > highest_index:
			highest_index = index
	if focused != null and focused != highest_index:
		cards[focused].unfocus()
	if highest_index >= 0:
		focused = highest_index
		cards[focused].focus()
		
# ------------------------------- HELPERS ------------------------------- #

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
			cards[i].position.y =  pow((hand_height/2) - ((hand_height / (cards.size()-1)) * i),2)
			cards[i].rotation_degrees = (-rot_range / 2) + ((rot_range / (cards.size()-1)) * i)

# OLD CODE DELETE EVENTUALLY WHEN CURRENT IMPLEMENTATION IS GOOOOOD

# focus on the highest index card that is being hovered over
func on_Card_hovered(card):
	var index = cards.find(card)
	#if none focused, select index
	if focused == null:
		cards[index].focus()
		focused = index
	#if hovering a higher index card,  deselect old one, select index
	elif index > focused:
		cards[focused].unfocus()
		cards[index].focus()
		focused = index
	#if hovering a lower (or same) index card, nothing

# unfocus if unhovered and focus a new card if also hovered
func on_Card_unhovered(card):
	var index = cards.find(card)
	#if unhovering a lower index card than selected, nothing
	#if unhovering the focused card
	if index == focused:
		cards[focused].unfocus()
		var next_hover = null
		# check for hover on lower index cards, select highest
		for i in range(0,focused):
			if cards[i].hovered == true:
				next_hover = i
		focused = null
		if next_hover != null:
			cards[next_hover].focus()
			focused = next_hover
