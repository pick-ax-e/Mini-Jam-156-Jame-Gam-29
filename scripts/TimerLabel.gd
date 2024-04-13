extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()


func update():
	var time_left = int(Singleton.time_left)
	var minutes = int(time_left / 60)
	var seconds = int(time_left % 60)
	
	var minutes_str = str(minutes)
	var seconds_str = str(seconds)
	
	if seconds < 10:
		seconds_str = "0" + seconds_str
	
	text = minutes_str + ":" + seconds_str
