extends Control

@export var game:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if event is InputEventKey:
		if event.pressed:
			Singleton.timer.start(300)
			get_tree().change_scene_to_packed(game)


func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()
