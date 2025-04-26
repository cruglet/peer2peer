extends Node

var airplay_check_subprocess: Subprocess

func _ready() -> void:
	airplay_check_subprocess = Subprocess.new()
	
	if OS.get_name() == "macOS":
		airplay_check()
		airplay_check_subprocess.binded_failure.connect(airplay_check)


func airplay_filter(line: String) -> bool:
	if line.contains("Mirror: On"):
		return true
	return false

func airplay_check() -> void:
	airplay_check_subprocess.run_threaded("system_profiler", ["SPDisplaysDataType"])
	airplay_check_subprocess.bind_filter(airplay_filter)
	airplay_check_subprocess.binded_success.connect(found_airplay)
	

func found_airplay() -> void:
	get_tree().quit()
