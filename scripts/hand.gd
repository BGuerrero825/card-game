extends Node2D

const CARD = preload("res://Card.tscn")
var cards = []
var hand_width
var rot_range
var hand_height
var hand_size := 4
var selected = null

# Called when the node enters the scene tree for the first time.
func _ready():
	# initialize hand with 4 cards
	for i in range(0, hand_size):
		var new_card = CARD.instance()
		cards.append(new_card)
		self.add_child(new_card)
		new_card.index = i
		new_card.set_type("j1")
		new_card.connect("hovered", self, "on_Card_hovered")
		new_card.connect("unhovered", self, "on_Card_unhovered")
	
	position_cards()
	
func _process(delta):
	pass

func get_selected_card():
	return cards[selected]

func position_cards():
	#scale offsets with hand size
	hand_width = 25 * cards.size()
	hand_height = 10 * cards.size()
	rot_range = 10 + 5 * cards.size()
	# if hand is one card, set transform to zero
	if cards.size() == 1:
		cards[0].position = Vector2(0,0)
		cards[0].rotation_degrees = 0
	#if hand is greater than one, set x and y offsets and rotation angle of cards based on position in hand
	elif(cards.size() > 1):
		for i in range(0,cards.size()):
			cards[i].position.x = (-hand_width / 2) + ((hand_width / (cards.size()-1)) * i)
			cards[i].position.y =  abs((hand_height/2) - ((hand_height / (cards.size()-1)) * i))
			cards[i].rotation_degrees = (-rot_range / 2) + ((rot_range / (cards.size()-1)) * i)

func remove_card(index):
	#remove card from hand and scene
	on_Card_unhovered(index)
	cards[index].queue_free()
	cards.remove(index)
	#reassign indeces of other cards
	for new_index in range(index, cards.size()):
		cards[new_index].index = new_index
	#reposition cards 
	position_cards()
	

# on card emit signal for area_mouse_entered
func on_Card_hovered(index):
	#if none selected, select index
	if selected == null:
		cards[index].select()
		selected = index
	#if hovering a higher index card,  deselect old one, select index
	elif index > selected:
		cards[selected].deselect()
		cards[index].select()
		selected = index
	#if hovering a lower (or same) index card, nothing
	#print("hovered ", index)

# on card emit signal for area_mouse_exited
func on_Card_unhovered(index):
	#if unhovering a lower index card, nothing
	#if unhovering the selected card
	if index == selected:
		cards[selected].deselect()
		var next_hover = null
		#check for hover on lower index cards, select highest
		for i in range(0,selected):
			if cards[i].hovered == true:
				next_hover = i
		selected = null
		if next_hover != null:
			cards[next_hover].select()
			selected = next_hover
	#print("unhovered ", index)
