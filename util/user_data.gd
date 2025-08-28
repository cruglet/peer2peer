class_name UserData extends Node

static var user: User

static var config_path: String:
	get():
		if Debug.SANDBOX:
			return OS.get_data_dir().path_join("p2p").path_join("sandbox_%s" % P2P.seed)
		return OS.get_data_dir().path_join("p2p")
	
static func fetch() -> User:
	var user_file: FileAccess = FileAccess.open(config_path.path_join("user"), FileAccess.READ)
	
	if user_file == null:
		P2P.logged_out.emit()
		return user
	
	var fetched_user: User = user_file.get_var(true)
	if fetched_user:
		user = User.new()
		user.username = fetched_user.username
		user.user_id = fetched_user.user_id
		user.friends_list = fetched_user.friends_list
		user.modulate_pfp = fetched_user.modulate_pfp
		user.about = fetched_user.about
		P2P.logged_in.emit()
	else:
		P2P.logged_out.emit()
	return user

static func store() -> void:
	if !DirAccess.dir_exists_absolute(config_path):
		DirAccess.make_dir_recursive_absolute(config_path)
	
	var user_file: FileAccess = FileAccess.open(config_path.path_join("user"), FileAccess.WRITE)
	user_file.store_var(user, true)

static func fetch_profile_picture(data: PackedByteArray = []) -> ImageTexture:
	if !data:
		return load("res://meta/icons/default_user_icon.svg") 
	
	var image: Image = Image.new()
	var err: Error = image.load_png_from_buffer(data)
	if err != OK:
		err = image.load_jpg_from_buffer(data)
		if err != OK:
			err = image.load_svg_from_buffer(data)
			if err != OK:
				return load("res://meta/icons/default_user_icon.svg")
				
	return ImageTexture.create_from_image(image)


static func fetch_messages(conversation_id: int) -> Array[Dictionary]:
	var path: String = config_path.path_join(str(conversation_id))
	if not FileAccess.file_exists(path):
		return []

	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var data: Variant = file.get_var(true)
	file.close()

	if data is Array:
		return data
	return []


static func store_message(conversation_id: int, encrypted_message: PackedByteArray, author_id: int) -> void:
	var path: String = config_path.path_join(str(conversation_id))
	var messages: Array[Dictionary] = []

	if FileAccess.file_exists(path):
		var read_file: FileAccess = FileAccess.open(path, FileAccess.READ)
		var past_messages: Variant = read_file.get_var(true)
		if past_messages is Array:
			messages = past_messages
		read_file.close()

	var new_message: Dictionary = {
		"message": encrypted_message,
		"author": author_id,
		"time": Time.get_unix_time_from_system()
	}
	messages.append(new_message)

	var write_file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	write_file.store_var(messages)
	write_file.close()
