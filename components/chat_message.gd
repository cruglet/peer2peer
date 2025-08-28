extends Control
@export_group("Variables")
@export var author_id: int
@export var author_name: String
@export var message_time: float
@export var message_data: PackedByteArray
@export var sequential: bool
@export var author_color: Color = Color.WHITE

@export_group("Exports")
@export var username_label: Label
@export var message_label: Label
@export var time_label: Label
@export var user_icon: TextureRect

@export var sequential_message_label: Label
@export var sequential_time_label: Label

@export var primary_container: Container
@export var sequential_container: Container

func _ready() -> void:
	if !author_id or !message_time:
		queue_free()
	
	custom_minimum_size.y = primary_container.custom_minimum_size.y
		
	if sequential:
		primary_container.hide()
		sequential_container.show()
		custom_minimum_size.y = sequential_container.custom_minimum_size.y
	else:
		primary_container.show()
		sequential_container.hide()
		custom_minimum_size.y = primary_container.custom_minimum_size.y
	
	user_icon.self_modulate = author_color
	username_label.text = author_name
	message_label.text = Encrypt.decode_string(message_data)
	sequential_message_label.text = Encrypt.decode_string(message_data)
	
	time_label.text = Time.get_datetime_string_from_unix_time(int(message_time)).replace("T", " * ")
	sequential_time_label.text = Time.get_time_string_from_unix_time(int(message_time))
