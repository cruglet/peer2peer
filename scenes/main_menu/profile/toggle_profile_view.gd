extends Node

@export var profile_button: SidebarButton
@export var profile_view_container: MarginContainer
@export var chat_view: MarginContainer

func _ready() -> void:
	_on_profile_view_pressed()

func _on_profile_view_pressed(_a = null) -> void:
	chat_view.visible = false
	profile_view_container.show()
