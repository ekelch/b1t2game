extends Node2D

@export_group("hsv")
@export_range(0.0, 1.0, 0.01) var hsv_h_start: float = 0.5
@export_range(0.0, 1.0, 0.01) var hsv_h_end: float = 0.5
@export_group("sva")

@export_range(0.0, 1.0, 0.01) var hsv_s: float = 0.5
@export_range(0.0, 1.0, 0.01) var hsv_v: float = 0.5
@export_range(0.0, 1.0, 0.01) var hsv_a: float = 1.0

@onready var bunny: CharacterBody2D = $Bunny
@onready var start_pos: Marker2D = $Markers/StartPos
@onready var end_pos: Marker2D = $Markers/EndPos
@onready var extra_platforms: Node2D = $ExtraPlatforms

@onready var spawn_ref: PackedScene = preload("res://scenes/spawn_point.tscn")
@onready var spawns: Node2D = $Spawns

var delta_y: float = 0
var bloom_index := 0

func _physics_process(_delta: float) -> void:
	modulate_color()
	MusicPlayer.updatePos(bunny.position)

func modulate_color() -> void:
	delta_y = (start_pos.global_position.y - bunny.global_position.y) / -end_pos.global_position.y
	var displacement_pct = clamp(delta_y, 0, 1)
	var hsv_h = hsv_h_start + displacement_pct * (hsv_h_end - hsv_h_start)
	var primary_color = Color.from_hsv(hsv_h, displacement_pct * hsv_s, hsv_v, hsv_a)
	var background_color = Color.from_hsv(hsv_h, hsv_s / 2, hsv_v / 2, hsv_a)
	
	RenderingServer.global_shader_parameter_set("primary_color", primary_color)
	RenderingServer.global_shader_parameter_set("secondary_color", background_color)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		reset_position()
	if event.is_action_pressed("special"):
		checkSpecial()

func checkSpecial():
	if Ui.charge >= 100:
		bloom()
	else:
		print('cannot bloom')
	
func bloom():
	Ui.set_charge(-100)
	for child in extra_platforms.get_children():
		if !child.visible:
			child.spawn()
			return

func reset_position() -> void:
	bunny.velocity = Vector2.ZERO
	if spawns.get_child_count() == 0:
		bunny.position = Vector2.ZERO
	else:
		bunny.position = get_last_spawn().position

func _on_reset_timer_timeout() -> void:
	reset_position()

func get_last_spawn() -> SpawnPoint:
	return spawns.get_child(spawns.get_child_count() - 1)
	
func _on_killzone_body_entered(_body: Node2D) -> void:
	$Killzone/ResetTimer.start()
