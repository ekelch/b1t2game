extends Node2D

@onready var bunny: CharacterBody2D = $Bunny
@onready var start_pos: Marker2D = $StartPos
var delta_y: float = 0
const max_y = 1000

func _process(_delta: float) -> void:
	delta_y = (start_pos.global_position.y - bunny.global_position.y) / max_y
	var mod = 1 - clamp(delta_y, start_pos.global_position.y, max_y)
	bunny.modulate = Color(mod, 1., mod, 1.)

func _on_reset_timer_timeout() -> void:
	get_tree().reload_current_scene()

func _on_killzone_body_entered(_body: Node2D) -> void:
	$Killzone/ResetTimer.start()
