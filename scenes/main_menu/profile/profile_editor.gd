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
	
	sidebar_profile_button.sidebar_button_icon.self_modulate = pfp_edit.self_modulate
	sidebar_profile_button.idle_icon_color = pfp_edit.self_modulate
	sidebar_profile_button.hover_icon_color = pfp_edit.self_modulate
	save_button.disabled = true


func _on_profile_changed(__ = null) -> void:
	save_button.disabled = false

func _on_user_color_button_color_changed(color: Color) -> void:
	var user_color: Color = color
	user_color.v = lerpf(0.8, 1, user_color.v)
	pfp_edit.self_modulate = user_color
	save_button.disabled = false
