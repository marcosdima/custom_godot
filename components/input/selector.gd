@tool
extends Component
class_name Selector

@export var values: Array[String] = []
@export var text_size: int = 10

var contenedor: Contenedor
var selection: Text
var go_left: Icon
var go_right: Icon

var index = 0

func _ready() -> void:
	super()
	self.set_components()


func set_components() -> void:
	## Set text
	var t = Text.new()
	
	t.content = "Choose" if Engine.is_editor_hint() || self.values.is_empty() else self.values[self.index]
	t.font_size = self.text_size if self.text_size else 10
	t.font = load("res://static/fonts/CaviarDreams.ttf")
	t.color = self.color
	t.margin_bottom = 5
	t.text_animations['Trigger'].do = TextAnimationHandler.TextDo.Wave
	self.selection = t
	
	## Create icons.
	var l = Icon.new()
	l.default = Icon.DefaultIcons.Play
	l.color = self.color
	l.rotate = 180
	l.connect("click_released_on", self.previus)
	self.go_left = l
	
	var r = Icon.new()
	r.default = Icon.DefaultIcons.Play
	r.color = self.color
	r.connect("click_released_on", self.next)
	self.go_right = r
	
	## Set contenedor and Add as children.
	var c = self.set_contenedor()
	c.add_child(l)
	c.add_child(t)
	c.add_child(r)
	
	## Set layout.
	c._set_layout()
	
	## Set layout fields.
	c.get_variable_field(Fields.VariableFields.LayoutContenedor)['vertical'] = false
	
	l.get_variable_field(Fields.VariableFields.Layout)['fill'] = 20
	t.get_variable_field(Fields.VariableFields.Layout)['fill'] = 60
	r.get_variable_field(Fields.VariableFields.Layout)['fill'] = 20
	
	## Set layout again.
	c._set_layout()


func set_contenedor() -> Contenedor:
	var c: Contenedor = Contenedor.new()
	
	if self.contenedor:
		self.contenedor.queue_free()
	
	c.layout_type = Instantiator.LayoutType.Sausage
	c.set_real_size(self.get_real_size())
	
	self.add_child.call_deferred(c)
	
	self.contenedor = c
	return c


func editor_settings() -> void:
	super()
	self.set_components()


func get_text() -> String:
	return self.selection.content


func rewrite_text(move: int) -> void:
	self.index += move
	
	var valid_index = self.values.size() - 1
	
	if self.index > valid_index:
		self.index = 0
	elif self.index < 0:
		self.index = valid_index
	
	self.selection.content = self.values[self.index]
	self.selection.queue_redraw()
	self.selection.emit_signal('trigger')
	self.emit_signal('trigger')


func next() -> void:
	self.rewrite_text(1)


func previus() -> void:
	self.index -= 1
	self.rewrite_text(-1)


func set_values(arr: Array[String]) -> void:
	self.values = arr
