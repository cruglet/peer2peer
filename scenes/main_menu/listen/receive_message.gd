extends Node

func _ready() -> void:
	P2P.incoming_message.connect(received_message)
	
func received_message(user_id: int, raw_message: PackedByteArray) -> void:
	var message: String = raw_message.get_string_from_utf8()
