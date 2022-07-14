extends Node2D

var hand_size := 5
var players := []

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().root, "ready")
	players.append(get_node("Player"))
	deal_cards(hand_size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func deal_cards(num_cards):
	if !$Deck:
		print("No deck exists to deal cards from.")
		return
	# spawn in cards from the deck to players in round robin order
	for i in range(0, num_cards):
		for j in range(0, players.size()):
			draw_card(players[j], $Deck)
			
func draw_card(to, from):
	var card = from.remove_card()
	to.receive_card(card, from)
	
