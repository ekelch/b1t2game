extends CharacterBody2D


const SPEED = 260.0
const JUMP_VELOCITY = -400.0
const BOOST_MODIFIER = 1.4
const GRAV_MOD_SCALAR = 2.5

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
	var boosted := Input.is_action_pressed("boost")
	handle_direction(direction, boosted)

	move_and_slide()

func handle_direction(direction: float, boosted: bool):
	if direction:
		velocity.x = direction * SPEED * (BOOST_MODIFIER if boosted else 1.)
		sprite.play("running")
		sprite.flip_h = true if direction < 0 else false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprite.play("idle")

func jump():
	if can_jump:
		velocity.y = JUMP_VELOCITY
		can_jump = false

func _on_floor_timer_timeout() -> void:
	can_jump = false
