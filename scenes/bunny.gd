extends CharacterBody2D


const MAX_SPEED = 260.0
const JUMP_VELOCITY = -400.0
const GRAV_MOD_SCALAR = 2.5
const accel = 900

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var floor_timer: Timer = $FloorTimer

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

	var direction := Input.get_axis("left", "right")
	handle_direction(direction, delta)

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

func _on_floor_timer_timeout() -> void:
	can_jump = false
