extends Node2D

# Version 1 - image zoom and pan 
# Allows zoom in (up

onready var paneA = $paneA
onready var paneB = $paneB

func _ready():
	panel_active(true, false)

func _on_Button_Pane_A_active_pressed():
	panel_active(true, false)

func _on_Button_Pane_B_active_pressed():
	panel_active(false, true)
	
func _input(event):
	if event.is_action_pressed("paneA_active"):
		panel_active(true, false)
	if event.is_action_pressed("paneB_active"):
		panel_active(false, true)

func panel_active(paneA_active, paneB_active):
	if paneA_active && !paneB_active:
		paneA.isActive = true
		paneB.isActive = false
	if !paneA_active && paneB_active:
		paneA.isActive = false
		paneB.isActive = true
	if !paneA_active && !paneB_active:
		paneA.isActive = false
		paneB.isActive = false
