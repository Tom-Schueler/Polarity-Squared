extends CheckBox


func GodmodeToggled(toggled_on: bool) -> void:
	Global.game.godModeEnabled = toggled_on


func _ready() -> void:
	button_pressed = Global.game.godModeEnabled
