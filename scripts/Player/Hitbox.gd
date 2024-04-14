class_name player_hitbox extends ShapeCast2D
const length = 100;
func updateRot(vec2Dir:Vector2):
	if vec2Dir != null:
		target_position = vec2Dir.normalized() * length

func tickHitbox(damage):
	var hits = collision_result
	for hit in hits:
		if hit is Enemy:
			print("fella has been hit")
			hit.take_damage(damage)

