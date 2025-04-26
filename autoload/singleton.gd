extends Node

func _ready() -> void:
	if OS.get_name() != "macOS":
		AirplayCheck.queue_free()
