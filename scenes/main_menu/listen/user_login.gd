extends Node

@export var online_users_container: VBoxContainer

const USER_BUTTON = preload("res://components/sidebar_button.tscn")


func _ready() -> void:
	P2P.user_logged_in.connect(check_user)
	P2P.user_profile_fetched.connect(add_user_to_list)

func check_user(user_id: int) -> void:
	match P2P.visibility:
		P2P.VISIBILITY_FRIENDS:
			if user_id in UserData.user.friends_list:
				P2P.broadcast(P2P.PROFILE_GET)
		P2P.VISIBILITY_OPEN:
				P2P.broadcast(P2P.PROFILE_GET)
				print("NOT IN LIST BUT ADDING ANYWAY TF")

func add_user_to_list(user_id: int, user: User) -> void:
	var user_button: SidebarButton = USER_BUTTON.duplicate(true).instantiate()
	P2P.user_list.set(user_id, user)
	
	user_button.texture = UserData.fetch_profile_picture(user.profile_picture_data)
	
