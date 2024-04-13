class_name Enemy
extends CharacterBody2D

enum State { IDLE, ACTIVE }

@export_category("Enemy Settings")
@export var type: String
@export var health: int
@export var attack_damage: int
@export var speed: float

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var start_position = global_position

var state = State.IDLE
var is_attacking = false
var target_position: Vector2

func _physics_process(delta: float):
	if state == State.IDLE:
		if is_attacking:
			_cancel_attack()
		
		navigation_agent.target_position = start_position
	else:
		_set_movement_target()
	
	move_to_target(delta)
	
	if state == State.IDLE:
		return
	
	if _can_attack():
		is_attacking = true
		
	if is_attacking:
		_do_attack(delta)
		

# Handles the movement of an enemy
func move_to_target(delta: float):
	var target = navigation_agent.get_next_path_position()
	
	if navigation_agent.is_navigation_finished() || is_attacking:
		return
		
	var direction = global_position.direction_to(target)
	
	move_and_collide(direction * speed * delta)

func _set_movement_target():
	pass
	
func _cancel_attack():
	pass

# Can the enemy attack?
func _can_attack() -> bool:
	return false

# perform the attack
func _do_attack(delta: float) -> void:
	pass
