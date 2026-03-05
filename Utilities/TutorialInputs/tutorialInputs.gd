extends Label


@export var input : String


func _ready() -> void:
	if (not InputMap.has_action(input)):
		return
	
	var events : Array[InputEvent] = InputMap.action_get_events(input)
	
	var arrow : Sprite2D = load("res://Assets/UIElements/Tutorial/arow.tscn").instantiate()
	match events[0].as_text():
		"Up":
			arrow.position = -position
			add_child(arrow)
			return
		
		"Left":
			arrow.position = -position
			arrow.rotation_degrees = 270
			add_child(arrow)
			return
		
		"Down":
			arrow.position = -position
			arrow.rotation_degrees = 180
			add_child(arrow)
			return
		
		"Right":
			arrow.position = -position
			arrow.rotation_degrees = 90
			add_child(arrow)
			return
	
	text = events[0].as_text()
