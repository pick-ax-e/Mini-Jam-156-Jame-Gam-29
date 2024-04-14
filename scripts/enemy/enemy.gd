class_name Enemy
extends RigidBody2D

@export_category("Enemy Settings")
@export var type: String
@export var health: float
@export var attack_damage: float
@export var speed: float

@onready var health_bar: ColorRect = $hp/fill
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var start_position = global_position
@onready var max_health = health

var is_agroed = false
var is_attacking = false
var target_position: Vector2
var _use_navigation = true

func _ready():
	set_physics_process(false)
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	call_deferred("_nav_setup")

func _nav_setup():
	NavigationServer2D.map_changed.connect(Callable(_nav_ready))

func _nav_ready(_rid):
	set_physics_process(true)
	NavigationServer2D.map_changed.disconnect(Callable(_nav_ready))

func _process(_delta: float) -> void:
	health_bar.scale = Vector2(clampf(health / max_health, 0, 1), 1)
	if Input.is_action_just_pressed("attack1"):
		take_damage(1)

func _physics_process(delta: float):
	if not is_agroed:
		if is_attacking:
			_cancel_attack()
		
		navigation_agent.target_position = start_position
	else:
		_set_movement_target()
	
	move_to_target(delta)
	
	if not is_agroed:
		return
	
	if _can_attack():
		is_attacking = true
		
	if is_attacking:
		_do_attack(delta)

# Handles the movement of an enemy
func move_to_target(_delta: float):
	navigation_agent.velocity = linear_velocity
	
	if navigation_agent.is_navigation_finished() || !_use_navigation:
		return
		
	var target = navigation_agent.get_next_path_position()
	var new_velocity = global_position.direction_to(target) * speed
	
	if navigation_agent.avoidance_enabled:
		navigation_agent.velocity = new_velocity
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2):
	if _use_navigation:
		linear_velocity = safe_velocity

func _set_movement_target():
	pass
	
func _cancel_attack():
	pass

# Can the enemy attack?
func _can_attack() -> bool:
	return false

# perform the attack
func _do_attack(_delta: float) -> void:
	pass

func take_damage(damage: float):
	pass

func _on_death():
	pass
