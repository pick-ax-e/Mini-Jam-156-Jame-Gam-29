extends Node

@onready var timer
@onready var player_node

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.start(300)
	timer.timeout.connect(_on_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	emit_signal("Update timer", timer.time_left)

func _on_timer_timeout():
	reset()
	emit_signal("Reset")

func reset():
	pass
