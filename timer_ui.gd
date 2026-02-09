extends CanvasLayer

var time_elapsed: float = 0.0
var is_running: bool = true

@onready var timer_label: Label = $TimerLabel

func _ready() -> void:
	update_display()

func _process(delta: float) -> void:
	if is_running:
		time_elapsed += delta
		update_display()

func update_display() -> void:
	var minutes = int(time_elapsed) / 60
	var seconds = int(time_elapsed) % 60
	var milliseconds = int((time_elapsed - int(time_elapsed)) * 100)
	timer_label.text = "%02d:%02d.%02d" % [minutes, seconds, milliseconds]

func stop() -> void:
	is_running = false
