extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var label = $Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	#init()

func init(type):
	#print("make a type: ",type)
	label.to_string("Draw a : ", type, " at:", get_global_mouse_position())
	#label.text = str("Draw a : ", type, " at:", get_global_mouse_position())
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
