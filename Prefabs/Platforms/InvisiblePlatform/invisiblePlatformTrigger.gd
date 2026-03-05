@tool
extends Area2D

var collider: CollisionShape2D
var tileMapLayer : TileMapLayer
@export var fadeOutTime : float = 0
var alpha = 1.0
var instantiated : bool = false

var collided : bool = false

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		if has_node("Trigger Area") && !instantiated:
			collider = CollisionShape2D.new()
			tileMapLayer = preload("res://Prefabs/Tilemap/Tilemap.tscn").instantiate()
			collider.name = "Trigger Area"
			add_child(collider)
			add_child(tileMapLayer)
			collider.set_owner(get_tree().edited_scene_root)
			tileMapLayer.set_owner(get_tree().edited_scene_root)
			collider.shape = RectangleShape2D.new()
			instantiated = true

func _ready() -> void:
	if Engine.is_editor_hint():
		set_process(false)

func _on_body_entered(body: Node2D) -> void:
	if not Engine.is_editor_hint():
		if body.is_in_group("Player"):
			collided = true
			set_process(true)
		
func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if(tileMapLayer != null && collided):
			alpha -= delta / fadeOutTime
			tileMapLayer.modulate = Color(1,1,1,alpha)
			if(alpha <= 0):
				queue_free()
