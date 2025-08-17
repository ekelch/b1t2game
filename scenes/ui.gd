extends CanvasLayer
@export var charge := 0
@onready var bloom_bar: ProgressBar = %BloomBar
@onready var elapsed_time_label: Label = $ElapsedTimeLabel
@onready var time_update_timer: Timer = $TimeUpdateTimer
const formatFlowers = "You collected %s of %s flowers"
var collected = 0
@onready var pickups: Node2D = $"../Level/Pickups"

func _ready() -> void:
	$VBoxContainer/zHint.hide()
	$VBoxContainer2.hide()

func showEndScreen():
	$VBoxContainer2/time.text = "Time Elapsed - " + getFormatTime()
	$VBoxContainer2/flowers.text = formatFlowers % [collected, pickups.get_child_count()]
	$VBoxContainer2.show()
	$ElapsedTimeLabel.hide()
	time_update_timer.stop()
	
func flower_collected() -> void:
	set_charge(20)
	collected += 1

func set_charge(delta: int) -> void:
	charge += delta
	bloom_bar.value = charge
	$VBoxContainer/zHint.visible = charge >= 100

func get_charge() -> int:
	return charge
	
func getFormatTime() -> String:
	@warning_ignore("integer_division")
	var se: int = Time.get_ticks_msec() / 1000
	@warning_ignore("integer_division")
	return str(se / 60).pad_zeros(2) + ":" + str(se % 60).pad_zeros(2)

func _on_time_update_timer_timeout() -> void:
	elapsed_time_label.text = getFormatTime()
