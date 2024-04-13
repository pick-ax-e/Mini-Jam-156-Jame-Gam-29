extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()


func update():
	var time_left = int(Singleton.time_left)
	var minutes = floor(time_left / 60)
	var seconds = floor(time_left % 60)
	
	var minutes_str = str(minutes)
	var seconds_str = str(seconds)
	
	add_theme_color_override("font_color", Color.BLACK)
	
	if seconds < 10:
		seconds_str = "0" + seconds_str
		if minutes == 0:
			add_theme_color_override("font_color", Color.RED)
	
	text = minutes_str + ":" + seconds_str
