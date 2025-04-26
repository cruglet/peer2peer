extends Node

var airplay_check_subprocess: Subprocess

func _ready() -> void:
	if OS.get_name() != "macOS":
		return
	
	airplay_check_subprocess = Subprocess.new()
	
	# Bind signals before starting
	airplay_check_subprocess.binded_success.connect(found_airplay)
	airplay_check_subprocess.binded_failure.connect(on_airplay_check_failed)
	airplay_check_subprocess.bind_filter(airplay_filter)
	
	# Run subprocess
	airplay_check_subprocess.run_threaded("system_profiler", ["SPDisplaysDataType"])
	airplay_check_subprocess.start()


func airplay_filter(line: String) -> bool:
	return line.contains("Mirror: On")


func found_airplay(_line: String) -> void:
	get_tree().quit()


func on_airplay_check_failed() -> void:
	airplay_check_subprocess.clean_thread()
	await airplay_check_subprocess.thread_cleaned
	airplay_check_subprocess.run_threaded("system_profiler", ["SPDisplaysDataType"])
	airplay_check_subprocess.start()
