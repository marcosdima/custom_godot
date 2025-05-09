@tool
extends Component
class_name Boton

@export var label: String = ""
@export var text_size: int = 10

var contenedor: Contenedor
var label_component: Text

func _ready() -> void:
	super()
	self.connect('resize', self.set_components)


func set_components() -> void:
	self.set_contenedor()
	self.set_text()


func set_contenedor() -> void:
	if self.contenedor:
		self.remove_child(self.contenedor)
	
	var c = Contenedor.new()
	c.layout_type = Instantiator.LayoutType.Rail
	self.add_child(c)
	c.set_real_size(self.get_real_size())
	c.set_real_position(self.get_real_position())
	self.contenedor = c


func set_text() -> void:
	var t = Text.new()
	t.content = self.label
	t.font_size = self.text_size
	t.font = load("res://static/fonts/CaviarDreams.ttf")
	t.color = self.color
	
	self.contenedor.add_child(t)
	self.contenedor._set_layout()
