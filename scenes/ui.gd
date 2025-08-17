extends CanvasLayer
var charge := 0
@onready var bloom_bar: ProgressBar = %BloomBar

func set_charge(delta: int) -> void:
	charge += delta
	bloom_bar.value = charge

func get_charge() -> int:
	return charge
