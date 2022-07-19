extends Node2D

export var hand_size := 6
var players := []

# Called when the node enters the scene tree for the first time.
func _ready():
	# yield until all players have been loaded into the scene (TEMP, players will eventually be added dynamically and connect through script
	yield(get_tree().root, "ready")
	players.append(get_node("Player"))
	get_node("Player").connect("send_request", self, "process_send_request")
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

# TEMP IMPLEMENTATION, proof of concept, player to table transfer
func process_send_request(card):
	$Player.remove_child(get_node("Player/Requests").get_child(0))
	add_child(card)
	card.position = get_global_mouse_position()
	
