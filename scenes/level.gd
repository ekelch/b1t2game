extends Node2D

@export_group("hsv")
@export_range(0.0, 1.0, 0.01) var hsv_h_start: float = 0.5
@export_range(0.0, 1.0, 0.01) var hsv_h_end: float = 0.5
@export_group("sva")

@export_range(0.0, 1.0, 0.01) var hsv_s: float = 0.5
@export_range(0.0, 1.0, 0.01) var hsv_v: float = 0.5
@export_range(0.0, 1.0, 0.01) var hsv_a: float = 1.0

@onready var bunny: CharacterBody2D = $Bunny
@onready var tileset: TileMapLayer = $TileMapLayer
@onready var background: TileMapLayer = $Background
@onready var start_pos: Marker2D = $Markers/StartPos
@onready var end_pos: Marker2D = $Markers/EndPos

var delta_y: float = 0

func _physics_process(_delta: float) -> void:
	modulate_colors()

func modulate_colors() -> void:
	delta_y = (start_pos.global_position.y - bunny.global_position.y) / -end_pos.global_position.y
	var displacement_pct = clamp(delta_y, 0, 1)
	var hsv_h = hsv_h_start + displacement_pct * (hsv_h_end - hsv_h_start)
	var modulate_amount = Color.from_hsv(hsv_h, displacement_pct * hsv_s, hsv_v, hsv_a)
	bunny.modulate = modulate_amount
	tileset.modulate = modulate_amount
	background.modulate = Color.from_hsv(hsv_h, hsv_s / 2, hsv_v / 2, hsv_a)
	
	RenderingServer.global_shader_parameter_set("apply_color", bunny.modulate)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()

func _on_reset_timer_timeout() -> void:
	get_tree().reload_current_scene()

func _on_killzone_body_entered(_body: Node2D) -> void:
	$Killzone/ResetTimer.start()
