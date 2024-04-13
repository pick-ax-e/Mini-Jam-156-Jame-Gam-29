extends Label

@onready var health

# Called when the node enters the scene tree for the first time.
func _ready():
	health = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health = Singleton.player_node.player_health
	text = "HP: " + str(health)
	if health > 75:
		set("theme_override_colors/font_color", Color(0.0,1.0,0.0,1.0))
	if 50 < health < 75:
		set("theme_override_colors/font_color", Color(1.0,1.0,0.0,1.0))
	if 25 < health < 50:
		set("theme_override_colors/font_color", Color(1.0,0.75,0.0,1.0))
	if health < 25:
		set("theme_override_colors/font_color", Color(1.0,0.0,0.0,1.0))
