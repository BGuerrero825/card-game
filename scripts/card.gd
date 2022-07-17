extends Node2D

var id := -1
var value := -1
# 2 digits: ( (h|c|d|s) + (2-9|t|j|q|k|a) ) | (b1|b2|j1|j2)
export var type := "b1"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func set_value(src_id, src_val):
	id = src_id
	value = src_val
	$Sprite.frame = src_val
