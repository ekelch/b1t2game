extends Node2D

@onready var player: AudioStreamPlayer2D = $MusicPlayer
@onready var player_2: AudioStreamPlayer2D = $MusicPlayer2
@onready var interval_timer: Timer = $IntervalTimer

var current_song_i = 0

func updatePos(update_position: Vector2) -> void:
	position = update_position

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("skip"):
		playNextSong()

func playNextSong() -> void:
	var p1on = player.playing
	player.stop()
	player_2.stop()
	
	if p1on:
		player_2.play()
	else:
		player.play()
	
func _on_player_finished() -> void:
	interval_timer.start()

func _on_interval_timer_timeout() -> void:
	playNextSong()
	
