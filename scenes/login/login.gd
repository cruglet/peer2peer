extends PanelContainer

@export var username_edit: LineEdit
@export var user_icon: TextureRect
@export var user_id: Label
@export var about_edit: TextEdit
@export var user_pfp_dialog: FileDialog
@export var http: HTTPRequest

var pfp_path: String

func _ready() -> void:
	var hue: float = randf_range(0, 1)
	var sat: float = randf_range(0.3, 0.8)
	user_icon.self_modulate = Color.from_hsv(hue, sat, 1.0)
	user_id.text = "#%s" % generate_id()
	
func generate_id() -> int:
	return randi_range(100000000, 999999999)


func _on_user_pfp_dialog_file_selected(path: String) -> void:
	var pfp_img: Image = Image.load_from_file(path)
	user_icon.texture = ImageTexture.create_from_image(pfp_img)
	user_icon.self_modulate = Color.WHITE
	pfp_path = path


func _on_create_profile_button_pressed() -> void:
	var new_user: User = User.new()
	new_user.username = username_edit.text
	#new_user.profile_picture_data = FileAccess.get_file_as_bytes(pfp_path)
	new_user.user_id = int(user_id.text.replace('#', ''))
	new_user.modulate_pfp = user_icon.self_modulate
	new_user.about = about_edit.text
	new_user.friends_list = []
	
	UserData.user = new_user
	UserData.store()
	
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/main_menu/home.tscn")

 
func _on_pfpurl_changed_text_changed(new_text: String) -> void:
	if "http" not in new_text:
		return
	
	http.request(new_text)
