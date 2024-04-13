class_name BasicEnemy
extends Enemy

enum AttackState { NONE, CHARGING, LUNGING, RECHARGING }
enum AnimationState { IDLE, RUN, CHARGE, LUNGE, RECHARGE}
enum AnimationDirection {UP, DOWN, LEFT, RIGHT}

const ANIMATION_STATE_MAP = {
	AnimationState.IDLE: "idle",
	AnimationState.RUN: "run",
	AnimationState.CHARGE: "charge",
	AnimationState.LUNGE: "lunge",
	AnimationState.RECHARGE: "recharge"
}

const ANIMATION_DIRECTION_MAP = {
	AnimationDirection.UP: "up",
	AnimationDirection.DOWN: "down",
	AnimationDirection.LEFT: "left",
	AnimationDirection.RIGHT: "right",
}

@export_category("Attack Settings")
@export var attack_range = 250
@export var charge_time: float = 0.5
@export var lunge_time: float = 0.25
@export var recharge_time: float = 1
@export var lunge_speed: float = 2000

var attack_direction: Vector2
var charge_position: Vector2

var attack_state = AttackState.NONE
var animation_state = AnimationState.IDLE
var animation_direction = AnimationDirection.RIGHT

@onready var player = Singleton.player_node
@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_timer: Timer = $attack_timer
@onready var targetting_timer: Timer = $targetting_timer

func get_animation_name() -> String:
	return ANIMATION_STATE_MAP[animation_state] + "_" + ANIMATION_DIRECTION_MAP[animation_direction]

func _process(delta: float) -> void:
	super._process(delta)
	_handle_animation()

func _handle_animation():
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
	attack_timer.stop()
	is_attacking = false

# Basic enemy can attack if it is within x units of the player
func _can_attack() -> bool:
	return global_position.distance_to(player.global_position) <= attack_range && !is_attacking

# charges up lunge, then captures the direction to the player and lunges towards them
func _do_attack(delta: float):
	match attack_state:
		AttackState.NONE:
			attack_state = AttackState.CHARGING
			charge_position = global_position
			attack_timer.start(charge_time)
			targetting_timer.start(charge_time * 3.0/4.0)
		AttackState.LUNGING:
			lunge(delta)

func lunge(delta: float):		
	move_and_collide(attack_direction * lunge_speed * delta)

func _on_attack_timer_timeout() -> void:
	attack_timer.stop()
	match attack_state:
		AttackState.CHARGING:
			attack_state = AttackState.LUNGING
			attack_timer.start(lunge_time)
		AttackState.LUNGING:
			attack_state = AttackState.RECHARGING
			attack_timer.start(recharge_time)
		AttackState.RECHARGING:
			attack_state = AttackState.NONE
			is_attacking = false


func _on_targetting_timer_timeout() -> void:
	attack_direction = global_position.direction_to(player.global_position)
	targetting_timer.stop()
