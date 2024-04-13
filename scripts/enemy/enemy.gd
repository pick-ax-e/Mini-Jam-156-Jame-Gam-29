class_name Enemy
extends CharacterBody2D

enum State { IDLE, ACTIVE }

@export_category("Enemy Settings")
@export var type: String
@export var health: int
@export var attack_damage: int
@export var speed: float

@onready var start_position = global_position

var state = State.IDLE
var is_attacking = false

func _physics_process(delta: float):
	if state == State.IDLE:
		if is_attacking:
			_cancel_attack()
		
		if global_position.distance_to(start_position) > 1:
			move_and_collide(global_position.direction_to(start_position) * speed * delta)
		return
	
	_movement(delta)
	
	if _can_attack():
		is_attacking = true
		
	if is_attacking:
		_do_attack(delta)
		
func _cancel_attack():
	pass

# Handles the movement of an enemy
func _movement(delta: float):
	pass

# Can the enemy attack?
func _can_attack() -> bool:
	return false

# perform the attack
func _do_attack(delta: float) -> void:
	pass
