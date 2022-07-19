# ONLY ONE DECK OF CARDS CAN EXIST IN A GAME SCENE AT A TIME. CARD ID'S FOR GLOBAL REGONITION ARE DETERMINED IN THE DECK CLASS.
extends Node2D

const CARD = preload("res://Card.tscn")
const STANDARD_SIZE = 52

export var standard := true
export var jokers := true
# allow user to specify a custom set of cards to use, ex. "1-12x3, 24x5, 52" would produce 3 of all heart cards, 5 ace of clubs, and 1 red joker" 
export var custom_deck := ""
#TODO: allow options / dynamic set sizing
var deck_size = STANDARD_SIZE
var rng = RandomNumberGenerator.new()
# source set of cards which will be in play, repeated types are valid
var set := []
# index is "id" and value is card type
var ids := []
# index is order in pile and value "id"
var deck := []

# Called when the node enters the scene tree for the first time.
func _ready():
	# if custom set string detected (NOT IMPLEMENTED)
	if custom_deck != "":
		build_custom_deck()
		return
	# else build a standard set of cards
	else:
		for i in range(0, STANDARD_SIZE):
			set.append(i)
		if jokers:
				set.append(52)
				set.append(53)
	initialize_deck()
	shuffle_deck()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# randomize ids for all cards in the "set" for global identification
func initialize_deck():
	rng.randomize()
	# iterate through set and randomly insert card value in array "ids"
	for i in range(0, set.size()):
		var random = rng.randi_range(0, ids.size())
		ids.insert(random, set[i])
	print("ID values: ", ids)
	for j in range(0, ids.size()):
		deck.append(j)
	shuffle_deck()
	print("Deck order(IDs):", deck)

# shuffle a standard deck (52 or 54 cards) into a shuffled deck (logical array of values)
func shuffle_deck():
	rng.randomize()
	deck.shuffle()

# initializes and provides card to proper player
func send_card():
	# initialize a generic card
	var card = CARD.instance()
	# grab top card from deck's info and return to caller
	card.set_value(deck[0], ids[deck[0]])
	deck.remove(0)
	return card

func build_custom_deck():
	pass
