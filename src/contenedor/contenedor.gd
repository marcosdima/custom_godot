extends Ente
class_name Contenedor

@export var layout_type: Layout.LayoutType = Layout.LayoutType.Pages
@export var content: Dictionary
@export var config: Dictionary
@export var contenedor_animations: Dictionary

var layout: Layout
var ly_aux: Layout.LayoutType

func _ready() -> void:
	if !Engine.is_editor_hint():
		ContenedorAnimator.set_contenedor_animations(self)
		self.layout = Layout.create(self)
		super()
	self.ly_aux = self.layout_type


## This funcion will be called at each save.
func editor_settings() -> void:
	super()
	
	var ly_change = self.ly_aux != self.layout_type
	self.layout = Layout.create(self, ly_change)
	self.ly_aux = self.layout_type
	
	ContenedorAnimator.set_contenedor_animations(self)
