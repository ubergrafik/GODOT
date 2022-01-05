extends Node2D

enum {
	none,
	random,
	health,
	rupeegreen,
	rupeeblue,
	bomb
}

const RupeeLoot = preload("res://World/Rupee.tscn")
const HealthLoot = preload("res://World/Health.tscn")

var state = null
var positionToAdd = null

func init(LOOTTYPE, pos):
	state = LOOTTYPE
	positionToAdd = pos

func _ready():
	add_loot()

func add_loot():
	match state:
		random:
			pass

		health:
			var healthLoot = HealthLoot.instance()
			get_parent().add_child(healthLoot)
			healthLoot.global_position = positionToAdd
			
		rupeegreen:
			var rupeeLoot = RupeeLoot.instance()
			get_parent().add_child(rupeeLoot)
			rupeeLoot.global_position = positionToAdd

		rupeeblue:
			var rupeeLoot = RupeeLoot.instance()
			get_parent().add_child(rupeeLoot)
			rupeeLoot.global_position = positionToAdd

		bomb:
			pass

