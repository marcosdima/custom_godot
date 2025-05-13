@tool
extends Component
class_name IconSelector

@export var text_size: int = 10

var contenedor: Contenedor
var selector: Selector
var display: Icon

var index = 0

func _ready() -> void:
	super()
	self.set_components()


func set_components() -> void:
	## Create selector.
	var s = Selector.new()
	s.connect(
		'trigger',
		func():
			var k = self.selector.get_text()
			if Icon.DefaultIcons.has(k):
				self.display.default = Icon.DefaultIcons[k] 
			
			self.display.queue_redraw()
			self.selector.queue_redraw()
			self.display.emit_signal('trigger')
	)
	var aux: Array[String] = []
	
	for k in Icon.DefaultIcons.keys():
		if Icon.exists(k):
			aux.append(k)
	
	s.set_values(aux)
	s.color = self.color
	s.text_size = self.text_size if !Engine.is_editor_hint() else 10
	self.selector = s
	
	## Create display.
	var d = Icon.new()
	d.color = self.color
	if !Engine.is_editor_hint():
		d.default = Icon.DefaultIcons[aux[0]]
	else:
		d.default = Icon.DefaultIcons["Mate"]
	self.display = d
	
	## Set contenedor.
	var c = self.set_contenedor()
	c.add_child(self.display)
	c.add_child(self.selector)
	
	## Set layout.
	c._set_layout()
	
	## Set layout fields.
	c.get_variable_field(Fields.VariableFields.LayoutContenedor)['vertical'] = true
	
	d.get_variable_field(Fields.VariableFields.Layout)['fill'] = 80
	d.animations['Trigger'].do = AnimationHandler.Do.Pop
	
	s.get_variable_field(Fields.VariableFields.Layout)['fill'] = 20
	
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
