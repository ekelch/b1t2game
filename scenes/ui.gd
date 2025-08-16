extends CanvasLayer
@onready var bloom_bar: ProgressBar = %BloomBar

func increment():
	bloom_bar.value += 5
