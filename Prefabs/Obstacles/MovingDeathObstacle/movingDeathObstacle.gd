extends Node2D

@export var speed : float = 1000
@export var startDelay : float = 0.0
@export var pauseBetweenPoints : float = 1.0
##Moves the platform backwards if it reaches the end point
@export var reverse : bool = true
##Platform starts over at beginning point if it reaches end point.
@export var startOver : bool = false
##It takes this many seconds to reach max speed
@export var accelerationTime : float = 1
@export_enum("Electrefied", "Impaled", "Dismembered") var causeOfDeath : String = "Electrefied"


var prevIndex : int = 0
var index : int = 0
var points : PackedVector2Array

var distanceOfPoints
var time = 0.0
var timer = 0.0
var currentSpeed = 0.0
var targetVelocity = 0.0

func _ready() -> void:
	set_process(false)
	$StartDelay.wait_time = startDelay + 0.1
	$StartDelay.start()

func _on_start_delay_timeout() -> void:
	for child in get_children():
		if(child.is_in_group("Point")):
			points.append(child.global_position)
	if(points.is_empty()): return
	global_position = points[0]
	distanceOfPoints = global_position.distance_to(points[index])
	set_process(true)

func _physics_process(delta: float) -> void:
	if(points.is_empty()): return
	MoveToNextPoint(delta)

func GetNextPoint() -> void:
	if(index > points.size() - 1):  
		index = 0
		if(reverse):
			points.reverse()
			index = 1
	distanceOfPoints = global_position.distance_to(points[1])
	currentSpeed = 0.0
	timer = 0.0

func MoveToNextPoint(delta) -> void:
	if(global_position == points[index]):
		timer += delta
		if(timer >= pauseBetweenPoints):
			prevIndex = index
			index += 1
			GetNextPoint()
			if(global_position == points[points.size() - 1] and startOver):
				index = 0
				global_position = points[0]
				
	var accelerationRate = speed / accelerationTime
	currentSpeed = min(currentSpeed + accelerationRate * delta, speed)
	targetVelocity = currentSpeed * delta
	global_position = global_position.move_toward(points[index], targetVelocity)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.has_signal("kill")):
		body.kill.emit(causeOfDeath ,"Dead")
		await get_tree().process_frame
