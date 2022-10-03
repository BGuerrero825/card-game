extends Node2D

var cards := []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# add card to hand to a specified index, or end of hand
func receive_card(card, index = null):
	if index != null:
		cards.insert(index, card)
	else:
		cards.push_front(card)
		card.rotation_degrees = rand_range(-8.0, 8.0)
	add_child(card)

func send_card(index = null):
	var card = null
	if index != null:
		pass
	else:
		card = cards.pop_front()
		remove_child(card)
	# if no cards remain, remove the stack
	if cards.size() < 1:
		self.queue_free()
	return card
