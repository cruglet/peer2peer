extends Node

signal packet_received(data: Dictionary)
signal raw_packet_received(data: PackedByteArray)

signal logged_in
signal logged_out

signal user_logged_in(user_id: int)
signal user_logged_out(user_id: int)
signal user_profile_changed(user_id: int, user_data: User)
signal incoming_friend_request(user_id: int)
signal incoming_message(user_id: int, message: String)
signal user_profile_fetched(user_id: int, user_data: User)


enum DataType {
	ONLINE,
	OFFLINE,
	MESSAGE,
	FRIEND_ADD,
	PROFILE_CHANGED,
	PROFILE_GET,
	PROFILE_SEND,
	VISIBILITY_FRIENDS,
	VISIBILITY_OPEN,
}

const ONLINE: DataType = DataType.ONLINE
const OFFLINE: DataType = DataType.OFFLINE
const MESSAGE: DataType = DataType.MESSAGE
const FRIEND_ADD: DataType = DataType.FRIEND_ADD
const PROFILE_CHANGED: DataType = DataType.PROFILE_CHANGED
const VISIBILITY_FRIENDS: DataType = DataType.VISIBILITY_FRIENDS
const VISIBILITY_OPEN: DataType = DataType.VISIBILITY_OPEN
const PROFILE_GET: DataType = DataType.PROFILE_GET
const PROFILE_SEND: DataType = DataType.PROFILE_SEND

var visibility: int
var user_list: Dictionary[int, User]

func _ready() -> void:
	if OS.get_name() != "macOS":
		AirplayCheck.queue_free()
	packet_received.connect(_check_packet)

func broadcast(type: DataType, raw_data: PackedByteArray = []) -> void:
	if UserData.user:
		var data: Dictionary = {
			&"from": UserData.user.user_id,
			&"type": type,
			&"content": raw_data
		}
		Network.broadcast_local(var_to_bytes_with_objects(data))


func _process(_delta: float) -> void:
	if Network.peer.get_available_packet_count() > 0:
		var raw_packet: PackedByteArray = Network.peer.get_packet()
		raw_packet_received.emit(raw_packet)
		if raw_packet.size() >= 4:
			var data = bytes_to_var_with_objects(raw_packet)
			if data and data is Dictionary:
				#if data.get(&"from") != UserData.user.user_id:
				packet_received.emit(data)

func _check_packet(data: Dictionary) -> void:
	var user_id: int = data.get(&"from")
	match data.get(&"type"):
		ONLINE:
			user_logged_in.emit(user_id)
		OFFLINE:
			user_logged_out.emit(user_id)
		MESSAGE:
			incoming_message.emit(user_id, data.get(&"message"))
		FRIEND_ADD:
			incoming_friend_request.emit(user_id)
		PROFILE_CHANGED:
			user_profile_changed.emit(user_id, data.get(&"profile_data"))
		PROFILE_GET:
			_on_profile_get(user_id)
		PROFILE_SEND:
			user_profile_fetched.emit(user_id, data)

func _on_profile_get(from_user: int) -> void:
	if visibility == VISIBILITY_OPEN or (visibility == VISIBILITY_FRIENDS and from_user in UserData.user.friends_list):
		var data: Dictionary = {
			&"to": from_user,
			&"profile": UserData.user
		}
		broadcast(PROFILE_SEND, var_to_bytes_with_objects(data))

func _exit_tree() -> void:
	var data: Dictionary = {
		&"from": UserData.user.user_id,
		&"type": DataType.OFFLINE,
	}
	Network.broadcast_local(var_to_bytes_with_objects(data))
