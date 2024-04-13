class_name BasicEnemy
extends Enemy

enum AttackState { NONE, CHARGING, LUNGING, RECHARGING }

@onready var player: Node2D = %test_player
@export var range = 50
@export var charge_time: float = 1
@export var lunge_speed: float = 100
@export var lunge_distance: float = 100
@export var recharge_time: float = 1

var attack_state = AttackState.NONE
var current_charge_time = 0
var attack_direction: Vector2
var charge_position: Vector2

# Basic enemy that moves/pathfinds towards the player
# when in range, lunges towards the player?

# Move/pathfind towards the plater
func _movement(delta: float):
	if is_attacking:
		return
	
	if global_position.distance_to(player.global_position) <= range:
		return
	
	velocity = global_position.direction_to(player.global_position) * speed * delta
	
	move_and_slide()

# Basic enemy can attack if it is within x units of the player
func _can_attack() -> bool:
	return position.distance_to(player.position) <= range && !is_attacking

# charges up lunge, then captures the direction to the player and lunges towards them
func _do_attack(delta: float):
	match attack_state:
		AttackState.NONE:
			attack_direction = position.direction_to(player.position)
			attack_state = AttackState.CHARGING
			charge_position = position
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
	if charge_position.distance_to(position) >= lunge_distance:
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
