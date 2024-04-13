class_name Enemy
extends CharacterBody2D

enum State { IDLE, ACTIVE }

@export_category("Enemy Settings")
@export var type: String
@export var health: float
@export var attack_damage: float
@export var speed: float

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var start_position = global_position

var state = State.IDLE
var is_attacking = false
var target_position: Vector2

func _ready():
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

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
	if navigation_agent.is_navigation_finished() || is_attacking:
		print("Test")
		navigation_agent.set_velocity_forced(Vector2.ZERO)
		velocity = Vector2.ZERO
		#move_and_slide()
		return
		
	var target = navigation_agent.get_next_path_position()
	var new_velocity = global_position.direction_to(target) * speed
	
	if navigation_agent.avoidance_enabled:
		navigation_agent.velocity = new_velocity
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	move_and_slide()

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

func take_damage(damage: float):
	pass
