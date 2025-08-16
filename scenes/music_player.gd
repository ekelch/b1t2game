extends Node2D

const music_path := "res://assets/music/"
@onready var resource_list = ResourceLoader.list_directory(music_path)
@onready var player: AudioStreamPlayer2D = $MusicPlayer
@onready var interval_timer: Timer = $IntervalTimer

var playback_position: float
var current_song_i = 0

func updatePos(update_position: Vector2) -> void:
	position = update_position

func playNextSong() -> void:
	player.stop()
	current_song_i = (current_song_i + 1) % len(resource_list)
	player.stream = AudioStreamMP3.load_from_file(music_path + resource_list.get(current_song_i))
	print(current_song_i)
	player.play()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("playpause"):
		if player.playing:
			playback_position = player.get_playback_position()
			player.stop()
		else:
			player.play(playback_position)
	if event.is_action_pressed("skip"):
		playNextSong()
	
func _on_player_finished() -> void:
	interval_timer.start()

func _on_interval_timer_timeout() -> void:
	playNextSong()
	
