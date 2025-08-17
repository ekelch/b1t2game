extends Area2D
@onready var pcamera: Camera2D = $"../Bunny/PlayerCamera"

func _on_body_entered(_body: Node2D) -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	MusicPlayer.playNextSong()
	Ui.showEndScreen()
	print('u won!')
	
	var tw = get_tree().create_tween()
	tw.tween_property(pcamera, "zoom", Vector2(4,4), 5.)
