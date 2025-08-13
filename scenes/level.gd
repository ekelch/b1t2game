extends Node2D

const hue_start: float = 23
const hue_end: float = 125

@export_group("hsv")
@export_range(0.0, 1.0, 0.01) var hsv_s: float = 0.5
@export_range(0.0, 1.0, 0.01) var hsv_v: float = 0.5
@export_range(0.0, 1.0, 0.01) var hsv_a: float = 1.0

@onready var bunny: CharacterBody2D = $Bunny
@onready var tileset: TileMapLayer = $TileMapLayer
@onready var start_pos: Marker2D = $Markers/StartPos
@onready var end_pos: Marker2D = $Markers/EndPos

var delta_y: float = 0

func _process(_delta: float) -> void:
	delta_y = (start_pos.global_position.y - bunny.global_position.y) / -end_pos.global_position.y
	var mod = clamp(delta_y, 0, 1)
	var hsv_h = (hue_start + mod * (hue_end - hue_start))/255
	bunny.modulate = Color.from_hsv(hsv_h, hsv_s, hsv_v, hsv_a)
	tileset.modulate = bunny.modulate

func _on_reset_timer_timeout() -> void:
	get_tree().reload_current_scene()

func _on_killzone_body_entered(_body: Node2D) -> void:
	$Killzone/ResetTimer.start()
