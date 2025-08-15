extends CharacterBody2D


const MAX_SPEED = 260.0
const JUMP_VELOCITY = -400.0
const GRAV_MOD_SCALAR = 2.5
const accel = 900

const run_asset_path := "res://assets/sounds/run/"
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var floor_timer: Timer = $FloorTimer
@onready var run_samples := ResourceLoader.list_directory(run_asset_path)
@onready var run_audio: AudioStreamPlayer2D = $RunAudio
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var run_sound_timer: Timer = $RunSoundTimer

var can_jump: bool = false

func _physics_process(delta: float) -> void:
	if is_on_floor() && !can_jump:
		can_jump = true
		
	if !is_on_floor():
		var grav = get_gravity() * delta
		var gravmod = clampf(abs(velocity.y * delta * GRAV_MOD_SCALAR), 0, 12.)
		grav.y += gravmod
		velocity += grav
		if floor_timer.is_stopped():
			floor_timer.start()
	
	if Input.is_action_just_pressed("jump"):
		jump()
		
	if Input.is_action_just_pressed("zoom"):
		animation_player.play("zoom_out")
	elif Input.is_action_just_released("zoom"):
		animation_player.play_backwards("zoom_out")
		

	var direction := Input.get_axis("left", "right")
	handle_direction(direction, delta)
	
	#if abs(velocity.x) > 0 && is_on_floor() && run_sound_timer.is_stopped():
		#run_sound_timer.start()
		#run_audio.stream = AudioStreamMP3.load_from_file(run_asset_path + run_samples.get(randi() % len(run_samples)))
		#run_audio.play()

	move_and_slide()

func handle_direction(direction: float, delta: float):
	if direction:
		velocity.x = clamp(velocity.x + direction * accel * delta, -MAX_SPEED, MAX_SPEED) 
		sprite.play("running")
		sprite.flip_h = true if direction < 0 else false
	else:
		velocity.x = move_toward(velocity.x, 0, accel * delta)
		sprite.play("idle")

func jump():
	if can_jump:
		velocity.y = JUMP_VELOCITY
		can_jump = false
		run_audio.stream = AudioStreamMP3.load_from_file(run_asset_path + run_samples.get(randi() % len(run_samples)))
		run_audio.play()

func _on_floor_timer_timeout() -> void:
	can_jump = false
