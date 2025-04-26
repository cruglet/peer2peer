class_name UserData extends Node

static var config_path: String:
	get():
		return OS.get_data_dir()
	
static func fetch() -> User:
	var user_data: User = User.new()
	
	var user_file: FileAccess = FileAccess.open(config_path.path_join("user"), FileAccess.READ)
	
	if user_file == null:
		print("L")
		return user_data
	
	var fetched_data: Dictionary = user_file.get_var(true)
	if fetched_data:
		print("W")
	else:
		print("L")
		
	return user_data
