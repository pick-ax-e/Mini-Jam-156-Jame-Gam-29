extends ShapeCast2D
var hitbox: ShapeCast2D
const length = 100;
var hits
func _ready():
	hitbox = $Hitbox1
func updateRot(vec2Dir:Vector2):
	hitbox.target_position = vec2Dir.normalized() * length

#func _physics_process(delta):
	#hits = hitbox.collision_result
	#for hit in hits:
		#if hit is Enemy:
			#var enemy: Enemy = hit
			
	
