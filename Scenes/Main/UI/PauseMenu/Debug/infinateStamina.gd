extends CheckBox


func InfinateStaminaToggled(toggled_on: bool) -> void:
	Global.game.infinateStaminaEnabled = toggled_on


func _ready() -> void:
	button_pressed = Global.game.infinateStaminaEnabled
