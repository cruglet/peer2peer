extends Node

@export var profile_button: SidebarButton
@export var profile_view_container: MarginContainer

var profile_view: bool = true

func _ready() -> void:
	_on_profile_view_pressed()

func _on_profile_view_pressed() -> void:
	profile_view = !profile_view
	
	if profile_view:
		profile_view_container.show()
	else:
		profile_view_container.hide()
