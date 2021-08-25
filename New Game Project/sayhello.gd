extends Panel

func _ready():
	get_node("Button").connect("pressed", self, "_on_button_pressed")
	
func _on_button_pressed():
	get_node("Label").text = "Hello!"


