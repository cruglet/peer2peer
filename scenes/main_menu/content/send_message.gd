extends Node

const CHAT_MESSAGE = preload("res://components/chat_message.tscn")

@export var message_input: TextEdit
@export var messages_vbox: VBoxContainer
var last_message_author: int = -1
var current_user: int = -1


func _ready() -> void:
	P2P.incoming_message.connect(func(user_id: int, msg_data: PackedByteArray) -> void:
		if user_id != UserData.user.user_id:
			add_message(user_id, Encrypt.decode_string(msg_data))
	)


func _process(_d: float) -> void:
	if Input.is_action_just_pressed("ui_text_newline"):
		pass
	elif Input.is_action_just_pressed("ui_text_submit"):
		var trimmed_message: String = message_input.text.lstrip(" \t\n").rstrip(" \t\n")
		message_input.text = ""
		add_message(UserData.user.user_id, trimmed_message)


func _assign_user(source: SidebarButton):
	var user: User = source.get_meta(&"user", User.new())
	current_user = user.user_id


func add_message(user_id: int, message: String):
	var msg = CHAT_MESSAGE.duplicate(true).instantiate()
	var user: User = P2P.fetch_user(user_id)
	
	if user_id == UserData.user.user_id:
		user = UserData.user
	
	msg.author_name = user.username
	msg.author_id = user.user_id
	msg.author_color = user.modulate_pfp
	msg.message_time = Time.get_unix_time_from_system()
	msg.message_data = Encrypt.string(message)
	
	if last_message_author == msg.author_id:
		msg.sequential = true
	
	messages_vbox.add_child(msg)
	last_message_author = msg.author_id
	
	var encrypted_message: PackedByteArray = Encrypt.string(message)
	
	UserData.store_message(current_user, encrypted_message, user.user_id)
	
	if user_id == UserData.user.user_id:
		P2P.broadcast(P2P.MESSAGE, encrypted_message)
