extends Node2D

# Version 1 - image zoom and pan 
# Allows zoom in (up to 4 times) 
# Allows zoom out (back to starting magnification) 
# Allows dragging/panning of image 

# Define max zoom in/out
# Define extents of panning
# Active panel
# Define key bindings
onready var isActive = false
onready var image = $Image
onready var zoomFactorText = $Zoom_factor_text
onready var zoom_factor = 0.1
const ZOOM_STEPS = 5
const MAX_ZOOM = 0.3
const MIN_ZOOM = 0.1
const PAN_FACTOR = 10
const VIEWPORT_WIDTH = 512
const VIEWPORT_HEIGHT = 600
onready var current_zoom = zoom_factor
var image_draggable = false

const drawItem = preload("res://Draw.tscn")


func _ready():
	updateZoomFactorText()

func _on_Button_zoom_in_pressed():
	if isActive:
		zoom("in")

func _on_Button_zoom_out_pressed():
	if isActive:
			zoom("out")

func _on_Area2D_input_event(viewport, event, shape_idx):
	if isActive:
		if Input.is_action_just_pressed("click"):
			image_draggable = true

func _on_Button_draw_rect_pressed():
	drawType("Rectangle")

func _on_Button_draw_text_pressed():
	drawType("Text")

func _input(event):
	if isActive:
		if event.is_action_pressed("zoom_in"):
			zoom("in")
		if event.is_action_pressed("zoom_out"):
			zoom("out")
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and not event.pressed:
				image_draggable = false
		if event.is_action_pressed("draw_rectangle"):
			drawType("Rectangle")
		if event.is_action_pressed("draw_text"):
			drawType("Text")

func _process(delta):
	if isActive:
		var input_vector = Vector2.ZERO
		input_vector.x = Input.get_action_strength("pan_right") - Input.get_action_strength("pan_left")
		input_vector.y = Input.get_action_strength("pan_down") - Input.get_action_strength("pan_up")
		input_vector = input_vector.normalized()

		var moveH = input_vector.x * PAN_FACTOR
		var moveV = input_vector.y * PAN_FACTOR	
	
		if image_draggable:
			image.global_position = get_global_mouse_position()
		
		if image_draggable == false:
			image.position.x += moveH
			image.position.y += moveV

func zoom(direction):
	if direction == "in":
		if current_zoom <= MAX_ZOOM:
			current_zoom += zoom_factor
			image.scale.x = current_zoom
			image.scale.y = current_zoom
	if direction == "out":
		if current_zoom > MIN_ZOOM:
			current_zoom -= zoom_factor
			image.scale.x = current_zoom
			image.scale.y = current_zoom
	updateZoomFactorText()
	
func updateZoomFactorText():
	zoomFactorText.text = str("Zoom: ", current_zoom)

func drawType(type):
	print("Draw ",type)
	# change cursor depending on mode
	# create instance
	var newItem = drawItem.instance()
	newItem.init(type)
	get_parent().add_child(newItem)
	newItem.global_position = get_global_mouse_position()

	# get origin anchor
