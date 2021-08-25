extends Node2D

func _ready():
	$Timer.connect("timeout", self, "_on_Timer_timeout")
	get_node("Button").connect("pressed", self, "_on_button_pressed")

func _on_Timer_timeout():
	$Sprite.visible = !$Sprite.visible

	
func _on_button_pressed():
	pass #pause/unpause

