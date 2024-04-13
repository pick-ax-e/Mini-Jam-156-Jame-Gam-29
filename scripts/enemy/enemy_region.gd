class_name EnemyRegion
extends Area2D

var enemies: Array[Enemy]

var is_active = false

func _ready():
	for child in get_children():
		if child is Enemy:
			enemies.append(child)

# unsure if checks and loops are expensive, can check every x steps if needed
func _physics_process(_delta: float) -> void:
	var bodies = get_overlapping_bodies()
	
	var contains_player = false
	
	for body in bodies:
		if body == Singleton.player_node:
			contains_player = true
			break
	
	if contains_player:
		# enemies are already activated, do nothing
		if is_active:
			return
		
		is_active = true
		for enemy in enemies:
			enemy.state = Enemy.State.ACTIVE
	else:
		is_active = false
		for enemy in enemies:
			enemy.state = Enemy.State.IDLE
