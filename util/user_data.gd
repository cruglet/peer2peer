class_name UserData extends Node

static var user: User

static var config_path: String:
	get():
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
		user.profile_picture_data = fetched_user.profile_picture_data
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

static func fetch_profile_picture(data: PackedByteArray = []) -> Texture2D:
	var new_img: Image = Image.new()
	var buf: PackedByteArray
	
	if data:
		buf = data
	else:
		buf = user.profile_picture_data
	
	if new_img.load_png_from_buffer(buf) == OK:
		pass
	elif new_img.load_jpg_from_buffer(buf) == OK:
		pass
	elif new_img.load_svg_from_buffer(buf) == OK:
		pass
	else:
		return load("res://meta/icons/default_user_icon.svg")
	
	return ImageTexture.create_from_image(new_img) 
