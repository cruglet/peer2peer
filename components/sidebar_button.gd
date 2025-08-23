@tool
class_name SidebarButton extends PanelContainer

@export var texture: Texture2D:
	set(tex):
		if sidebar_button_icon:
			sidebar_button_icon.texture = tex
		texture = tex
		
@onready var sidebar_button_icon_container: PanelContainer = %SidebarButtonCrop
@onready var sidebar_button_icon: TextureRect = %SidebarButtonIcon

@export var idle_color: Color = Color("#2e343c")
@export var hover_color: Color = Color("#29f2af")

@export var idle_icon_color: Color = Color("#ffffff")
@export var hover_icon_color: Color = Color("#147353")

@export var clipping: bool = true

@export var icon_scale: float = 1.0:
	set(s):
		icon_scale = s
		if sidebar_button_icon_container:
			sidebar_button_icon_container.scale = Vector2(s, s)

@export var hover_in_time: float = 0.2
@export var hover_out_time: float = 0.2


var bg_tween: Tween
var icon_tween: Tween
var scale_tween: Tween
var press_timer: Timer = Timer.new()


signal pressed(source: SidebarButton)


func _ready() -> void:
	press_timer.autostart = false
	press_timer.one_shot = true
	add_child(press_timer)
	await get_tree().process_frame
	_redraw()


func _redraw() -> void:
	_on_resized()
	sidebar_button_icon.self_modulate = idle_icon_color
	sidebar_button_icon_container.scale = Vector2(icon_scale, icon_scale)
	if !clipping:
		sidebar_button_icon_container.self_modulate = Color.TRANSPARENT
		sidebar_button_icon_container.clip_children = CanvasItem.CLIP_CHILDREN_DISABLED
	else:
		sidebar_button_icon_container.self_modulate = Color.WHITE
		sidebar_button_icon_container.clip_children = CanvasItem.CLIP_CHILDREN_ONLY
	texture = texture
	icon_scale = icon_scale

func new_col_tweens() -> void:
	bg_tween = get_tree().create_tween()
	bg_tween.set_ease(Tween.EASE_OUT)
	
	icon_tween = get_tree().create_tween()
	icon_tween.set_ease(Tween.EASE_OUT)


func _on_mouse_entered() -> void:
	new_col_tweens()
	bg_tween.tween_property(self, "self_modulate", hover_color, hover_in_time)
	icon_tween.tween_property(sidebar_button_icon, "self_modulate", hover_icon_color, hover_in_time)
	bg_tween.play()
	icon_tween.play()


func _on_mouse_exited() -> void:
	new_col_tweens()
	bg_tween.tween_property(self, "self_modulate", idle_color, hover_out_time)
	icon_tween.tween_property(sidebar_button_icon, "self_modulate", idle_icon_color, hover_out_time)
	bg_tween.play()
	icon_tween.play()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.button_mask == 1:
			_on_pressed()
		elif event.button_index == 1 and event.button_mask == 0:
			_on_released()


func _on_pressed() -> void:
	scale_tween = get_tree().create_tween()
	scale_tween.set_ease(Tween.EASE_OUT)
	scale_tween.tween_property(self, "scale", Vector2(1.1, 1.1), hover_in_time / 2)
	scale_tween.play()
	
	press_timer.start(0.4)
	

func _on_released() -> void:
	scale_tween = get_tree().create_tween()
	scale_tween.set_ease(Tween.EASE_OUT)
	scale_tween.tween_property(self, "scale", Vector2.ONE, hover_in_time / 2)
	scale_tween.play()
	
	if press_timer.time_left > 0:
		pressed.emit(self)

func _on_resized() -> void:
	pivot_offset = size / 2
	sidebar_button_icon_container.pivot_offset = sidebar_button_icon_container.size / 2
