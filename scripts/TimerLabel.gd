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
	
	set("theme_override_colors/font_color", Color(0.0,0.0,0.0,1.0))
	
	if seconds < 10:
		seconds_str = "0" + seconds_str
		if minutes == 0:
			set("theme_override_colors/font_color", Color(1.0,0.0,0.0,1.0))
	
	text = minutes_str + ":" + seconds_str
