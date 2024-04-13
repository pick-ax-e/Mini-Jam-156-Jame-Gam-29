extends Node

@onready var timer
@onready var player_node
@onready var time_left

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.start(300)
	timer.timeout.connect(_on_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_left = timer.time_left

func _on_timer_timeout():
	reset()
	emit_signal("Reset")

func reset():
	get_tree().reload_current_scene()
