extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

signal return_score(status)


func _on_btn_getScore_pressed():
	var valueReturn = JavaScript.eval("""
		ScormProcessGetValue('cmi.score.scaled');
	""")
	emit_signal("return_score", valueReturn)
