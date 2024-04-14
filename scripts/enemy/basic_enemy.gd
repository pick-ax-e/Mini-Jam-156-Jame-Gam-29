class_name BasicEnemy
extends Enemy

enum State { IDLE, MOVING, CHARGING, LUNGING, STUNNED, KNOCKED_BACK }
enum AnimationDirection {UP, DOWN, LEFT, RIGHT}

const ANIMATION_DIRECTION_MAP = {
	AnimationDirection.UP: "up",
	AnimationDirection.DOWN: "down",
	AnimationDirection.LEFT: "left",
	AnimationDirection.RIGHT: "right",
}

const STATE_ANIMATION_MAP = {
	State.IDLE: "idle",
	State.MOVING: "run",
	State.CHARGING: "charge",
	State.LUNGING: "lunge",
	State.KNOCKED_BACK: "stun",
	State.STUNNED: "stun",
}

@export_category("Attack Settings")
@export var attack_range = 250
@export var charge_time: float = 0.5
@export var lunge_time: float = 0.5
@export var recharge_time: float = 1
@export var lunge_speed: float = 4000

@export_category("Take Damage Settings")
@export var stun_duration: float = 1
@export var knockback_duration: float = 0.1
@export var knockback_strength: float = 1000

var attack_direction: Vector2
var charge_position: Vector2
var damage_direction: Vector2

var state = State.IDLE
var animation_direction = AnimationDirection.RIGHT

@onready var player = Singleton.player_node
@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_timer: Timer = $attack_timer
@onready var targetting_timer: Timer = $targetting_timer
@onready var stun_timer: Timer = $stun_timer
@onready var death_effect = preload("res://scenes/enemy_death_effect.tscn")

func get_animation_name() -> String:
	return STATE_ANIMATION_MAP[state] + "_" + ANIMATION_DIRECTION_MAP[animation_direction]

func _process(delta: float) -> void:
	super._process(delta)
	_handle_animation()

func _handle_animation():
	if linear_velocity.dot(Vector2.RIGHT) > 0.5:
		animation_direction = AnimationDirection.RIGHT
	elif linear_velocity.dot(Vector2.UP) > 0.5:
		animation_direction = AnimationDirection.UP
	elif linear_velocity.dot(Vector2.LEFT) > 0.5:
		animation_direction = AnimationDirection.LEFT
	elif linear_velocity.dot(Vector2.DOWN) > 0.5:
		animation_direction = AnimationDirection.DOWN
	
	if state == State.IDLE && linear_velocity.length() > 1:
		state = State.MOVING
	elif state == State.MOVING && linear_velocity.length() <= 1:
		state = State.IDLE

	if animator.animation != get_animation_name():
		animator.stop()
		animator.play(get_animation_name())

func _set_movement_target():
	navigation_agent.target_position = player.global_position

func _cancel_attack():
	state = State.IDLE
	attack_timer.stop()
	is_attacking = false
	_use_navigation = true

# Basic enemy can attack if it is within x units of the player
func _can_attack() -> bool:
	var is_in_range = global_position.distance_to(player.global_position) <= attack_range
	var correct_state = state == State.IDLE || state == State.MOVING
	
	return is_in_range && !is_attacking && correct_state 

# charges up lunge, then captures the direction to the player and lunges towards them
func _do_attack(_delta: float):
	match state:
		State.IDLE | State.MOVING:
			_use_navigation = false
			state = State.CHARGING
			charge_position = global_position
			attack_timer.start(charge_time)
			targetting_timer.start(charge_time * 3.0/4.0)
		State.LUNGING:
				pass
		_:
			linear_velocity = Vector2.ZERO

func _on_attack_timer_timeout() -> void:
	attack_timer.stop()
	match state:
		State.CHARGING:
			state = State.LUNGING
			attack_timer.start(lunge_time)
			apply_central_impulse(attack_direction * lunge_speed)
		State.LUNGING:
			state = State.STUNNED
			attack_timer.start(recharge_time)
		State.STUNNED:
			state = State.IDLE
			is_attacking = false
			_use_navigation = true

func _on_stun_timer_timeout() -> void:
	stun_timer.stop()
	match state:
		State.KNOCKED_BACK:
			state = State.STUNNED
			stun_timer.start(stun_duration)
		State.STUNNED:
			state = State.IDLE
			_use_navigation = true

func _on_targetting_timer_timeout() -> void:
	attack_direction = global_position.direction_to(player.global_position)
	targetting_timer.stop()

func take_damage(damage: float):
	attack_timer.stop()
	is_attacking = false
	_use_navigation = false
	
	state = State.KNOCKED_BACK
	stun_timer.start(knockback_duration)
	
	damage_direction = player.global_position.direction_to(global_position)
	apply_central_impulse(damage_direction * knockback_strength)
	
	# TODO: Damage flash
	
	health -= damage
	if health < 0:
		_on_death()

func _on_death():
	# TODO: Sprite fade out?
	var effect = death_effect.instantiate()
	effect.global_position = global_position
	get_tree().root.get_child(1).add_child(effect)
	queue_free()
