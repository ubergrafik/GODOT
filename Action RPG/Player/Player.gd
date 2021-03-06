extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

export var ACCELERATION = 500
# Setting up a constant for use in movement smoothing later
export var MAX_SPEED = 80
export var ROLL_SPEED = 120
export var FRICTION = 500

# enum - sets a set of constants - and gives it a value - 0, 1, 2 etc.
enum{
	MOVE,
	ROLL,
	ATTACK
}

# 2-element structure that can be used to represent positions in 2D space or any other pair of numeric values.
# Note: In a boolean context, a Vector2 will evaluate to false if it's equal to Vector2(0, 0). Otherwise, a Vector2 will always evaluate to true.
# Zero vector, a vector with all components set to 0.
# This is declared in the scope by adding it in here...
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var state = MOVE
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _ready():
	randomize()
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		
		ROLL:
			roll_state()
		
		ATTACK:
			attack_state()


func move_state(delta):
	# Create a variable to store the input vectors in - use the 'Vector2' as a 'template' to do this
	var input_vector = Vector2.ZERO
	# Add values into the variable
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	# Returns the vector scaled to unit length. Equivalent to v / v.length().
	input_vector = input_vector.normalized()
	#
	#
	# Determine if a key is being pressed
	# If it is, set  all components of 'velocity' to values in 'input_vector'
	# If not, set all components of 'velocity' to 0
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	
	
	# do the stuff!
	# delta - how long the previous frame took - because it is based on the 
	# frame rate of the machine, it can be used to smooth out action
	# e.g. velocity will be relative to frame rate - much nicer:)
	# BUT, it makes it REALLY slow on an ok machine, so multiply it by MAX_SPEED
	# Want to aim for pixels per second, rather than frame rate.
	
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func roll_state():
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func move():
	velocity = move_and_slide(velocity)

func roll_animation_finished():
	velocity = velocity * 0.8  
	state = MOVE

func attack_animation_finished():
	state = MOVE


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.6)
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)
	
func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
