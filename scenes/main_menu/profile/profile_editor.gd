extends Node

@export var about_edit: TextEdit
@export var username_edit: LineEdit
@export var pfp_edit: TextureRect

@export var save_button: Button
@export var pfp_dialog: FileDialog

@export var sidebar_profile_button: SidebarButton


var pfp_path: String

func _on_save_changes_button_pressed() -> void:
	UserData.user.username = username_edit.text
	UserData.user.modulate_pfp = pfp_edit.self_modulate
	UserData.user.about = about_edit.text
	
	
	var pfp_data: PackedByteArray = FileAccess.get_file_as_bytes(pfp_path) 
	if pfp_path and pfp_data:
		UserData.user.profile_picture_data = pfp_data
	
	UserData.store()
	
	sidebar_profile_button.texture = UserData.fetch_profile_picture()
	save_button.disabled = true



func _on_profile_changed(__ = null) -> void:
	save_button.disabled = false


func _on_user_icon_button_pressed() -> void:
	pfp_dialog.show()


func _on_user_pfp_dialog_file_selected(path: String) -> void:
	var pfp_img: Image = Image.load_from_file(path)
	pfp_edit.texture = ImageTexture.create_from_image(pfp_img)
	pfp_edit.self_modulate = Color.WHITE
	pfp_path = path
	save_button.disabled = false
