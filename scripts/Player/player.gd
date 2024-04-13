extends CharacterBody2D

const accel = 100;
const friction = 0.925;
const noInputFriction = 0.925;
var wishDir: Vector2 = Vector2.ZERO




func _physics_process(delta):
	handlePlayerMovement()
	
	
func handlePlayerMovement():
	wishDir.x = Input.get_axis("moveLeft","moveRight")
	wishDir.y = Input.get_axis("moveForward","moveBack")
	wishDir = wishDir.normalized()
	
	#if nothing pressed apply no input friction
	if wishDir.length() == 0:
		velocity *= noInputFriction
	else:
		#calculate multiplier to make things more responsive in opisite directions
		#var multi = float.dotProd velocity.normalized()
		velocity += wishDir * accel
		
	velocity *= friction
	move_and_slide()
	
