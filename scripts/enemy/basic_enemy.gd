class_name BasicEnemy
extends Enemy

enum AttackState { NONE, CHARGING, LUNGING, RECHARGING }
enum AnimationState { IDLE, RUN, CHARGE, LUNGE, RECHARGE}
enum AnimationDirection {UP, DOWN, LEFT, RIGHT}

@onready var player = Singleton.player_node
@onready var animator: AnimatedSprite2D = $AnimatedSprite2D

@export_category("Attack Settings")
@export var range = 50
@export var charge_time: float = 1
@export var lunge_speed: float = 100
@export var lunge_distance: float = 100
@export var recharge_time: float = 1

var attack_state = AttackState.NONE
var current_charge_time = 0
var attack_direction: Vector2
var charge_position: Vector2
var animation_state = AnimationState.IDLE
var animation_direction = AnimationDirection.RIGHT

func animation_state_to_string(animation_state: AnimationState) -> String:
	match animation_state:
		AnimationState.IDLE:
			return "idle"
		AnimationState.RUN:
			return "run"
		AnimationState.CHARGE:
			return "charge"
		AnimationState.LUNGE:
			return "lunge"
		AnimationState.RECHARGE:
			return "recharge"
		_:
			return "idle"

func animation_direction_to_string(animation_durection: AnimationDirection) -> String:
	match animation_direction:
		AnimationDirection.UP:
			return "up"
		AnimationDirection.RIGHT:
			return "right"
		AnimationDirection.DOWN:
			return "down"
		AnimationDirection.LEFT:
			return "left"
		_:
			return "right"

func get_animation_name() -> String:
	return animation_state_to_string(animation_state) + "_" + animation_direction_to_string(animation_direction)

func _process(delta: float) -> void:
	if velocity.dot(Vector2.RIGHT) > 0.5:
		animation_direction = AnimationDirection.RIGHT
	elif velocity.dot(Vector2.UP) > 0.5:
		animation_direction = AnimationDirection.UP
	elif velocity.dot(Vector2.LEFT) > 0.5:
		animation_direction = AnimationDirection.LEFT
	elif velocity.dot(Vector2.DOWN) > 0.5:
		animation_direction = AnimationDirection.DOWN
	
	match attack_state:
		AttackState.NONE:
			if velocity.length() > 1:
				animation_state = AnimationState.RUN
			else:
				animation_state = AnimationState.IDLE
		AttackState.CHARGING:
			animation_state = AnimationState.CHARGE
		AttackState.LUNGING:
			animation_state = AnimationState.LUNGE
		AttackState.RECHARGING:
			animation_state = AnimationState.RECHARGE
	
	if animator.animation != get_animation_name():
		animator.stop()
		animator.play(get_animation_name())

func _set_movement_target():
	navigation_agent.target_position = player.global_position

func _cancel_attack():
	attack_state = AttackState.NONE
	current_charge_time = 0
	is_attacking = false

# Basic enemy can attack if it is within x units of the player
func _can_attack() -> bool:
	return global_position.distance_to(player.global_position) <= range && !is_attacking

# charges up lunge, then captures the direction to the player and lunges towards them
func _do_attack(delta: float):
	match attack_state:
		AttackState.NONE:
			attack_direction = global_position.direction_to(player.global_position)
			attack_state = AttackState.CHARGING
			charge_position = global_position
		AttackState.CHARGING:
			charge_attack(delta)
		AttackState.LUNGING:
			lunge(delta)
		AttackState.RECHARGING:
			recharge_attack(delta)
	
func charge_attack(delta: float):
	if current_charge_time >= charge_time:
		attack_state = AttackState.LUNGING
		current_charge_time = 0
		return
	
	current_charge_time += delta

func lunge(delta: float):
	if charge_position.distance_to(global_position) >= lunge_distance:
		attack_state = AttackState.RECHARGING
		return
		
	move_and_collide(attack_direction * lunge_speed * delta)

func recharge_attack(delta: float):
	if current_charge_time >= recharge_time:
		attack_state = AttackState.NONE
		is_attacking = false
		current_charge_time = 0
		return
	
	current_charge_time += delta
