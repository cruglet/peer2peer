extends Node

@export var chat_username_label: Label
@export var chat_user_id_label: Label
@export var profile_view: MarginContainer
@export var chat_view: MarginContainer
@export var load_chat_messages: Node

func show_messages(source: SidebarButton) -> void:
	profile_view.visible = false
	chat_view.visible = true
	
	var user: User = source.get_meta(&"user")
	
	chat_username_label.text = user.username
	chat_user_id_label.text = "#" + str(user.user_id)
	
	load_chat_messages.load_chat_messages(user.user_id)
	
