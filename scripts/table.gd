extends Node2D

export var hand_size := 6
var players := []
var STACK = preload("res://Stack.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# yield until all players have been loaded into the scene (TEMP, players will eventually be added dynamically and connect through script
	yield(get_tree().root, "ready")
	players.append(get_node("Player"))
	get_node("Player").connect("to_table", self, "process_to_table")
	get_node("Player").connect("to_object", self, "process_to_object")
	get_node("Player").connect("from_object", self, "process_from_object")
	deal_cards(hand_size)


# HELPER FUNCTIONS -------------------------------------

func deal_cards(num_cards):
	if !$Deck:
		print("No deck exists to deal cards from.")
		return
	# spawn in cards from the deck to players in round robin order
	for _i in range(0, num_cards):
		for j in range(0, players.size()):
			transfer_card(players[j], $Deck)
			
func transfer_card(to, from, card = null):
	if card:
		from.send_card(card)
	else:
		card = from.send_card()
	to.receive_card(card)
	

# CALL FUNCTIONS -------------------------------------



# SIGNAL FUNCTIONS -------------------------------------

# process a player request to move an object to the table
func process_to_table(card, pos):
	#there should be a TRY here // or be moved to a "send_card" func on player
	$Player/Outbound.remove_child(card)
	
	var stack = STACK.instance()
	add_child(stack)
	stack.position = pos
	stack.receive_card(card)

func process_to_object(card, target):
	#there should be a TRY here // or be moved to a "send_card" func on player
	$Player/Outbound.remove_child(card)
	target.receive_card(card)
	
func process_from_object(source, target):
	var card = source.send_card()
	if not card == null:
		target.receive_card(card)
