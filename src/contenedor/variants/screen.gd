@tool
extends Contenedor
class_name Screen

@export var current_spaces: Dictionary:
	get():
		return SpaceManager.SPACES
	set(value):
		SpaceManager.SPACES = {}
@export var layout_configs: Dictionary:
	get():
		return Layout.CONFIGS
	set(value):
		Layout.CONFIGS = {}
@export var refresh: bool:
	set(value):
		self.set_viewport_area()
		refresh = false

func _ready() -> void:
	super()
	#self.set_viewport_area()
	self.get_viewport().connect("size_changed", self.set_viewport_area)


## [OVERWRITE]  Start Ente in Editor procediments.
func _notification(what: int) -> void:
	if what == NOTIFICATION_EDITOR_POST_SAVE:
		self.set_viewport_area()


func set_viewport_area() -> void:
	self.set_area(Rect2(Vector2.ZERO, self.get_parent_area_size()))
