extends StaticBody2D

const DestroyBushEffect = preload("res://Effects/DestroyBushEffect.tscn")
const Loot = preload("res://World/Lootinator.tscn")

onready var topSprite = $Top
onready var collision = $CollisionShape2D
onready var destroyed = false

export (int, "Bush", "Pot") var TYPE
export (int, "none","random","health","rupeegreen","rupeeblue","bomb") var LOOTTYPE

func add_destroy_effect():
	var destroyBushEffect = DestroyBushEffect.instance()
	get_parent().add_child(destroyBushEffect)
	destroyBushEffect.global_position = global_position
	destroyed = true
	
func _on_Hurtbox_area_entered(area):
	if destroyed == false:
		add_destroy_effect()
		showhideTopSprite()
		if LOOTTYPE != 0:
			addLoot(LOOTTYPE)
		#queue_free()
func showhideTopSprite():
	topSprite.visible = false
	collision.set_deferred("disabled", true)

func addLoot(LOOTTYPE):
	var pos = global_position
	var addLooties = Loot.instance()
	addLooties.init(LOOTTYPE, pos)
	get_parent().add_child(addLooties)
	addLooties.global_position = global_position
