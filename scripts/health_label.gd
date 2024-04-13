extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "HP: " + str(Singleton.player_node.player_health)
	if Singleton.player_node.player_health > 75:
		add_theme_color_override("font_color", Color.GREEN)
	if 50 < Singleton.player_node.player_health && Singleton.player_node.player_health < 75:
		add_theme_color_override("font_color", Color.YELLOW)
	if 25 < Singleton.player_node.player_health && Singleton.player_node.player_health < 50:
		add_theme_color_override("font_color", Color.ORANGE)
	if Singleton.player_node.player_health < 25:
		add_theme_color_override("font_color", Color.RED)
