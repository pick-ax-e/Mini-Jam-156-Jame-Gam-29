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
		add_theme_color_override("font_color", Color.GREEN)
	if 50 < health && health < 75:
		add_theme_color_override("font_color", Color.YELLOW)
	if 25 < health && health < 50:
		add_theme_color_override("font_color", Color.ORANGE)
	if health < 25:
		add_theme_color_override("font_color", Color.RED)
