extends Node

@export var discovery_toggle: SidebarButton

const OPEN_ICON = preload("res://meta/icons/open.svg")
const FRIENDS_ONLY_ICON = preload("res://meta/icons/friends.svg")

var open: bool = true

func _ready() -> void:
	await owner.ready
	_on_discovery_toggle_pressed()

func _on_discovery_toggle_pressed(_a = null) -> void:
	open = !open
	
	if open:
		discovery_toggle.texture = OPEN_ICON
		P2P.visibility = P2P.VISIBILITY_OPEN
		P2P.broadcast(P2P.VISIBILITY_OPEN)
	else:
		discovery_toggle.texture = FRIENDS_ONLY_ICON
		P2P.visibility = P2P.VISIBILITY_FRIENDS
		P2P.broadcast(P2P.VISIBILITY_FRIENDS)
