extends StaticBody2D

var collectable : Array
var keysToCollect : int = 0
var keysCollected : int = 0

#TODO: Change based on Designers choice
func _ready() -> void:
	for child in get_children():
		if(child.is_in_group("Key")):
			keysToCollect += 1
			collectable.append(child)
			child.obtainedKey.connect(KeyCollected.bind(child))

func KeyCollected(index):
	keysCollected += 1
	if(keysToCollect == keysCollected):#
		#TODO: Maybe not queue_free, call a func to play an animation
		queue_free()
	if(index.has_method("DeleteSelf")):
		index.DeleteSelf()
