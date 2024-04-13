class_name Enemy
extends CharacterBody2D

@export_category("Enemy Settings")
@export var type: String
@export var health: int
@export var attack_damage: int
@export var speed: float

var is_attacking: bool = false

func _physics_process(delta: float):
	_movement(delta)
	
	if _can_attack():
		is_attacking = true
		
	if is_attacking:
		_do_attack(delta)

# Handles the movement of an enemy
func _movement(delta: float):
	pass

# Can the enemy attack?
func _can_attack() -> bool:
	return false

# perform the attack
func _do_attack(delta: float) -> void:
	pass
