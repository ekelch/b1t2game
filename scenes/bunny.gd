extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -320.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var floor_timer: Timer = $FloorTimer
var can_jump: bool = false


func _physics_process(delta: float) -> void:
	if is_on_floor() && !can_jump:
		can_jump = true
		
	if !is_on_floor():
		velocity += get_gravity() * delta
		if floor_timer.is_stopped():
			floor_timer.start()
	
	if Input.is_action_just_pressed("jump") && can_jump:
		jump()
		can_jump = false

	var direction := Input.get_axis("left", "right")
	handle_direction(direction)

	move_and_slide()

func handle_direction(direction: float):
	if direction:
		velocity.x = direction * SPEED
		sprite.play("running")
		sprite.flip_h = true if direction < 0 else false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprite.play("idle")

func jump():
	velocity.y = JUMP_VELOCITY

func _on_floor_timer_timeout() -> void:
	can_jump = false
