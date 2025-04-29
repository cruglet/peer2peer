extends Control

@export var user_profile_button: SidebarButton

func _ready() -> void:
	P2P.logged_out.connect(login_prompt)
	UserData.fetch()
	
	if !UserData.user:
		return
	
	load_user()
	Network.peer.bind(Network.port)
	P2P.broadcast(P2P.DataType.ONLINE)


func load_user() -> void:
	user_profile_button.texture = load_pfp(UserData.user.profile_picture_data)
	user_profile_button.idle_icon_color = UserData.user.modulate_pfp
	user_profile_button.hover_icon_color = UserData.user.modulate_pfp


func login_prompt() -> void:
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/login/login.tscn")


func load_pfp(buf: PackedByteArray) -> ImageTexture:
	var new_img: Image = Image.new()
	
	if new_img.load_png_from_buffer(buf) == OK:
		pass
	elif new_img.load_jpg_from_buffer(buf) == OK:
		pass
	elif new_img.load_svg_from_buffer(buf) == OK:
		pass
	else:
		return load("res://meta/icons/default_user_icon.svg")
	
	return ImageTexture.create_from_image(new_img)
