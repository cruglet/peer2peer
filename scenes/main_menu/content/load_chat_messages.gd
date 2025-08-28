extends Node

@export var chat_vbox: VBoxContainer
const CHAT_MESSAGE = preload("res://components/chat_message.tscn")

var last_id: int = -1

func load_chat_messages(user_id: int) -> void:
	for child: Node in chat_vbox.get_children():
		child.free()
	
	var messages: Array[Dictionary] = UserData.fetch_messages(user_id)
	var sequential: bool = false
	
	if messages.is_empty():
		return
		
	for message: Dictionary in messages:
		var new_message = CHAT_MESSAGE.duplicate(true).instantiate()
		
		new_message.author_id = message.get(&"author")
		new_message.message_data = message.get(&"message")
		new_message.message_time = message.get(&"time")
		
		var author: User = P2P.fetch_user(new_message.author_id)
		new_message.author_name = author.username
		new_message.author_color = author.modulate_pfp
		
		if new_message.author_id == last_id:
			sequential = true
		else:
			sequential = false
			
		new_message.sequential = sequential
		
		last_id = new_message.author_id
		
		chat_vbox.add_child(new_message)
