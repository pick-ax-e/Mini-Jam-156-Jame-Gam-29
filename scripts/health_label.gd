extends Label

@onready var health = Singleton.player_node.player_health

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "HP: " + str(health)
	if health > 75:
		set("theme_override_colors/font_color", Color(0.0,1.0,0.0,1.0))
	if health < 25:
		set("theme_override_colors/font_color", Color(1.0,0.0,0.0,1.0))
