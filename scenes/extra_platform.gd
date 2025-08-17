extends StaticBody2D
class_name ExtraPlatform
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var pcamera: Camera2D = $"../../Bunny/PlayerCamera"
@onready var bunny: CharacterBody2D = $"../../Bunny"

const ANIMATION_DUR := 1.0
const WAIT_DUR = 0.6
static var first = true

func _ready() -> void:
	hide()
	collision_shape_2d.disabled = true

func spawn() -> void:
	if first:
		MusicPlayer.playNextSong()
		first = false
	collision_shape_2d.disabled = false
	var tw = get_tree().create_tween()
	tw.set_ease(Tween.EASE_OUT_IN)
	tw.set_parallel(false)
	tw.tween_property(pcamera, "position", position - bunny.position, ANIMATION_DUR)
	tw.tween_interval(WAIT_DUR)
	tw.tween_callback(show.bind())
	tw.tween_interval(WAIT_DUR)
	tw.tween_property(pcamera, "position", Vector2.ZERO, ANIMATION_DUR)
