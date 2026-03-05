@tool
extends Node2D

enum Section {Section1, Section2, Section3}
var tileMap : Texture2D

@export var section : Section = Section.Section1 :
	set(value):
		SetSpriteOfObjects(value)
	get:
		return _section

var _section : Section

func SetSpriteOfObjects(value: Section) -> void:
	if (_section == value):
		return
	
	if(value == Section.Section1):
		tileMap = preload("res://Assets/TileMap/TM_section1.png")
	elif(value == Section.Section2):
		tileMap = preload("res://Assets/TileMap/TM_section2.png")
	elif(value == Section.Section3):
		tileMap = preload("res://Assets/TileMap/TM_section3.png")
	else:
		print("Null")
	
	_section = value
	traverse_and_process_nodes(self)

func _ready() -> void:
	section = _section
	traverse_and_process_nodes(self)

func traverse_and_process_nodes(node: Node):
	for child in node.get_children():
		if child.has_method("GetNextPoint"):
			#print("Node with GetNextPoint method found:", child.name)
			find_and_update_sprite2d(child)
		if child.has_method("SetSprite"):
			child.sectionSprite = section
		
		if child is InstancePlaceholder:
			var instance = child.create_instance()
			if instance:
				traverse_and_process_nodes(instance)
		
		traverse_and_process_nodes(child)

func find_and_update_sprite2d(node: Node):
	if(tileMap == null): return
	for child in node.get_children():
		if child is Sprite2D:
			#print("Found Sprite2D in:", node.name, "->", child.name)
			child.texture = tileMap
		find_and_update_sprite2d(child)
