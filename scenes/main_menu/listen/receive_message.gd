extends Node

@export var main_chat_scroller: ScrollContainer 


func _ready() -> void:
	P2P.incoming_message.connect(received_message)


func received_message(_user_id: int, _raw_message: PackedByteArray) -> void:
	await get_tree().create_timer(0.5).timeout
	main_chat_scroller.scroll_vertical = 999999999
