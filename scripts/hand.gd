extends Node2D

# hand spacing and initialization variables
var cards = []
var hand_size := 5
var focused = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	pass

func get_focused_card():
	return cards[focused]

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

# add card to the end of the hand and attach signals
func receive_card(card):
	cards.append(card)
	self.add_child(card)
	card.connect("hovered", self, "on_Card_hovered")
	card.connect("unhovered", self, "on_Card_unhovered")
	position_cards()

func remove_card(index):
	#remove card from hand and scene
	on_Card_unhovered(index)
	cards[index].queue_free()
	cards.remove(index)
	#assign new indices to card objects after the one removed
	for i in range(index, cards.size()):
		cards[i].index = i
	#reposition cards 
	position_cards()

# focus on the highest index card that is being hovered over
func on_Card_hovered(id):
	var index = find_index(id)
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
func on_Card_unhovered(id):
	var index = find_index(id)
	#if unhovering a lower index card, nothing
	#if unhovering the focused card
	if index == focused:
		cards[focused].unfocus()
		var next_hover = null
		#check for hover on lower index cards, select highest
		for i in range(0,focused):
			if cards[i].hovered == true:
				next_hover = i
		focused = null
		if next_hover != null:
			cards[next_hover].focus()
			focused = next_hover

func find_index(id):
	for i in range(0, cards.size()):
		if cards[i].id == id:
			return i
