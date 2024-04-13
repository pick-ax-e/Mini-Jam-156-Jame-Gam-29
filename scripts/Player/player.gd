class_name Player extends CharacterBody2D

const accel = 100
const friction = 0.925
const noInputFriction = 0.8
const responsivenessMultiplier = 3
var wishDir: Vector2 = Vector2.ZERO


func _ready():
	Singleton.player_node = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	handlePlayerAttacks()
	handlePlayerMovement()
	handlePlayerAnimations()

func handlePlayerAnimations
	

func handlePlayerAttacks
	

func handlePlayerMovement():
	wishDir.x = Input.get_axis("moveLeft","moveRight")
	wishDir.y = Input.get_axis("moveForward","moveBack")
	wishDir = wishDir.normalized()
	
	#if nothing pressed apply no input friction
	if wishDir.length() == 0:
		velocity *= noInputFriction
	else:
		#calculate multiplier to make things more responsive in opisite directions
		var multi = (wishDir * -1).dot( velocity.normalized() ) + 1.0
		multi = (multi * responsivenessMultiplier) + 1
		velocity += wishDir * accel * multi
		
	velocity *= friction
	
	
	#now figure out rotation of the player
	move_and_slide()
	
