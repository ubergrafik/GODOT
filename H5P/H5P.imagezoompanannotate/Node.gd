extends Node

# Version 1 - image zoom and pan 
# Allows zoom in (up to 4 times) 
# Allows zoom out (back to starting magnification) 
# Allows dragging/panning of image 


# Define max zoom in/out
# Define extents of panning
# Active panel
# Define key bindings
onready var paneA = $Pane_A_image
onready var paneAzoomfactor = $Pane_A_zoom_factor
onready var zoom_factor = 0.1
const MAX_ZOOM = 0
const MIN_ZOOM = 0.4
const PAN_FACTOR = 10
onready var pane_a_current_zoom = zoom_factor
onready var pane_b_current_zoom = zoom_factor

func _ready():
	updateZoomFactorText()

func _on_Button_zoom_in_pressed():
	print("zoom IN pressed")
	zoom("in")

func _on_Button_zoom_out_pressed():
	print("zoom OUT pressed")
	zoom("out")

func _input(event):
	if event.is_action_pressed("zoom_in"):
		zoom("in")
	if event.is_action_pressed("zoom_out"):
		zoom("out")
	

func _process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("pan_right") - Input.get_action_strength("pan_left")
	input_vector.y = Input.get_action_strength("pan_down") - Input.get_action_strength("pan_up")
	input_vector = input_vector.normalized()
	
	var moveH = input_vector.x * PAN_FACTOR
	var moveV = input_vector.y * PAN_FACTOR	
	paneA.position.x += moveH
	paneA.position.y += moveV

func zoom(direction):
	if direction == "in":
		pane_a_current_zoom += zoom_factor
		paneA.scale.x = pane_a_current_zoom
		paneA.scale.y = pane_a_current_zoom
	if direction == "out":
		pane_a_current_zoom -= zoom_factor
		paneA.scale.x = pane_a_current_zoom
		paneA.scale.y = pane_a_current_zoom
	updateZoomFactorText()
	
func updateZoomFactorText():
	paneAzoomfactor.text = str("Zoom: ", pane_a_current_zoom)
