extends Node

@export var online_users_container: VBoxContainer
@export var chat_view: Node
@export var send_message: Node

const USER_BUTTON = preload("res://components/sidebar_button.tscn")


var loaded_users: Dictionary[int, User] = {
	
}


func _ready() -> void:
	P2P.user_visibility_changed.connect(check_user)
	P2P.user_profile_fetched.connect(add_user_to_list)


func check_user(user_id: int, user_visibility: P2P.DataType) -> void:
	print(user_id)
	var is_friend: bool = user_id in UserData.user.friends_list
	match P2P.visibility:
		P2P.VISIBILITY_FRIENDS:
			if is_friend:
				P2P.broadcast(P2P.PROFILE_GET)
		P2P.VISIBILITY_OPEN:
			if user_visibility == P2P.VISIBILITY_OPEN:
				P2P.broadcast(P2P.PROFILE_GET)
			elif user_visibility == P2P.VISIBILITY_FRIENDS and is_friend:
				P2P.broadcast(P2P.PROFILE_GET)


func add_user_to_list(user_id: int, content: Dictionary) -> void:
	if user_id in loaded_users:
		return
	
	var data: Dictionary = bytes_to_var_with_objects(content.get(&"content"))
	
	if data.get(&"to") != UserData.user.user_id:
		return
	
	var user: User = data.get(&"profile")
	
	if user.user_id == UserData.user.user_id:
		return
	
	var user_button: SidebarButton = USER_BUTTON.duplicate(true).instantiate()
	P2P.user_cache.set(user_id, user)
	user_button.texture = UserData.fetch_profile_picture()
	user_button.icon_scale = 1.8
	user_button.idle_icon_color = user.modulate_pfp
	user_button.hover_icon_color = user.modulate_pfp
	user_button.clipping = true
	
	user_button.set_meta(&"user", user)
	user_button.pressed.connect(chat_view.show_messages)
	user_button.pressed.connect(send_message._assign_user)
	
	loaded_users.set(user_id, user)
	
	P2P.user_cache.set(user_id, user)
	online_users_container.add_child(user_button)
