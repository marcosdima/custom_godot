extends Ente
class_name Contenedor

@export var layout_type: Layout.LayoutType = Layout.LayoutType.Pages

@export var sub_spaces: Dictionary = {}
@export var config: Dictionary

@export var contenedor_animations: Dictionary

var layout: Layout

func initialization_routine() -> void:
	super()
	self.set_layout()
	ContenedorAnimator.set_contenedor_animations(self)


func set_layout() -> void:
	Layout.create(self)
	self.layout.update_spaces()


func get_ente_by_key(s: String):
	for child in self.get_children():
		if child.name == s:
			return child


func add_space(k: String, space: Space) -> void:
	var aux = self.sub_spaces.duplicate()
	aux[k] = space
	self.sub_spaces = aux
