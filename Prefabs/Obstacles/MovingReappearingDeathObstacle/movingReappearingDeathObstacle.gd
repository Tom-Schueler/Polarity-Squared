extends Node2D

@export var reappearTimer : float = 1
@export var speed : float = 100
##Moves the platform backwards if it reaches the end point
@export var reverse : bool = true
##Platform starts over at beginning point if it reaches end point
@export var startOver : bool = false

var prevIndex : int = 0
var index : int = 0
var points : PackedVector2Array
var toggle : bool

func _ready() -> void:
	$Timer.wait_time = reappearTimer
	
	for child in get_children():
		if(child.is_in_group("Point")):
			points.append(child.global_position)
	if(points.size() == 0): return
	position = points[0]

func _process(delta: float) -> void:
	if(points.size() == 0): return
	GetNextPoint()
	MoveToNextPoint(delta)
	
func GetNextPoint() -> void:
	if(global_position == points[index]):
		prevIndex = index
		index += 1
		if(index > points.size() - 1):
			index = 0
			if(reverse):
				points.reverse()
func MoveToNextPoint(delta) -> void:
	if(global_position == points[points.size() - 1] and startOver):
		index = 0
		position = points[0]
	position = position.move_toward(points[index], speed * delta)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_tree().call_deferred("reload_current_scene")
		
func _on_timer_timeout() -> void:
	toggle = !toggle
	$".".visible = toggle
	$Area2D.monitoring = toggle
