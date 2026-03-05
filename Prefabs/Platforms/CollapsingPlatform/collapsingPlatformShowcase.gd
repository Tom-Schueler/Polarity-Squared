extends StaticBody2D


@onready var respawnTimer : Timer = $RespawnTimer
@onready var collapseTimer : Timer = $CollapseTimer
@onready var particle = preload("res://Prefabs/Platforms/CollapsingPlatform/particleEffect.tscn")


@export var collapseTimerInSeconds : float = 1
@export var shouldRespawn : bool = false
@export var respawnTimerInSeconds : float = 5
@export var shakeStrength : float = 1


var toggle : bool
var sprites : Array
var spritePosition : PackedVector2Array
var spriteGlobalPosition : PackedVector2Array
var randomSpritePosition : PackedVector2Array
var rng = RandomNumberGenerator.new()


func ToggleVisibility():
	var spritesIndex = 0
	
	for sprite in sprites:
		if(spritesIndex > sprites.size() - 1):
			spritesIndex = 0
		sprite.position = spritePosition[spritesIndex]
		sprite.global_position = spriteGlobalPosition[spritesIndex]
		spritesIndex += 1
		
	modulate = Color(1,1,1)
	toggle = !toggle
	$".".visible = toggle
	$CollisionShape2D.disabled = !toggle
	$Area2D/CollisionShape2D.disabled = !toggle

func Shake() -> void:
	var elapsed = 0.0
	var spritesIndex = 0
	var randomPos : Vector2 = Vector2.ZERO
	collapseTimer.start()
	$SFX_collapsing.play()
	
	while elapsed < collapseTimerInSeconds:
		var progress = elapsed / collapseTimerInSeconds
		for sprite in sprites:
			if(spritesIndex > sprites.size() - 1):
				spritesIndex = 0
			modulate = Color(.7,.7,.7, 1.4 - progress)
			randomPos = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)) * shakeStrength * progress
			
			sprite.position = spritePosition[spritesIndex] + randomPos
			spritesIndex += 1
			
		elapsed += get_process_delta_time()
		await get_tree().process_frame
		
	ToggleVisibility()


func _on_collapse_timer_timeout() -> void:
	respawnTimer.start()
	
	var spritesIndex = 0
	
	for sprite in sprites:
		if spritesIndex >= sprites.size():
			spritesIndex = 0
		var particleInstance = particle.instantiate()
		particleInstance.emitting = true
		get_parent().get_parent().add_sibling(particleInstance)
		
		particleInstance.position += spriteGlobalPosition[spritesIndex]
		spritesIndex += 1
	
	ToggleVisibility()

func _on_respawn_timer_timeout() -> void:
	$Area2D.set_deferred("monitoring", true)
	ToggleVisibility()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		Collapse()

func Collapse() -> void:
	$Area2D.set_deferred("monitoring", false)
	Shake()

func GetNextPoint() -> void:
	pass

func _ready() -> void:
	for child in get_children():
		if child is Sprite2D:
			sprites.append(child)
			spritePosition.append(child.position)
			spriteGlobalPosition.append(child.global_position)
			randomSpritePosition.append(Vector2(rng.randf_range(-1,1), rng.randf_range(-1,1)))
			
	toggle = !shouldRespawn
	
	respawnTimer.wait_time = respawnTimerInSeconds
	collapseTimer.wait_time = collapseTimerInSeconds


func _on_timer_timeout() -> void:
	Collapse()
