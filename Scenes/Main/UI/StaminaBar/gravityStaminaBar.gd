extends Control

@onready var player : CharacterBody2D = $".."

@onready var staminaBar = $ProgressBar

func _process(delta: float) -> void:
	if(player != null):
		staminaBar.value = player.currentStamina
		if(staminaBar.value == staminaBar.max_value):
			staminaBar.visible = false
		else:
			staminaBar.visible = true
