extends Node

var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.start(300)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer.timeout():
		reset()
		emit_signal("Reset")


func reset():
	pass
