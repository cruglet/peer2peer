extends Node

@export var profile_view_username: LineEdit
@export var profile_view_user_id: Label
@export var profile_view_image: TextureRect
@export var profile_view_about: TextEdit

func _ready() -> void:
	P2P.logged_in.connect(sync_profile)

func sync_profile() -> void:
	profile_view_username.text = UserData.user.username
	profile_view_user_id.text = "#%s" % UserData.user.user_id
	profile_view_image.texture = UserData.fetch_profile_picture()
	profile_view_image.self_modulate = UserData.user.modulate_pfp
	profile_view_about.text = UserData.user.about
