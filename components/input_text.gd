@tool
extends Component
class_name InputText

enum Action {
	Remove,
	Delete,
	Add,
	AddSpace,
}


@export var text_size: int = 16
@export var placeholder: String = "Write something..."
@export var max_length: int = 10

var contenedor: Contenedor
var line: Element
var text_display: Text

var input = ""

const VALID_KEYS = [
	"A","B","C","D","E","F","G","H","I","J","K","L","M",
	"N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
	"Á","É","Í","Ó","Ú","Ñ", "Space", "Backspace",
	"0","1","2","3","4","5","6","7","8","9"
]

func _ready() -> void:
	super()
	self.set_components()
	self.trigger_on_focus()


func _input(event: InputEvent) -> void:
	super(event)
	if self.input_handler.focus and event is InputEventKey and event.is_released():
		var input_key = event as InputEventKey
		var key_text = input_key.as_text_keycode()
		
		var valid_key = self.VALID_KEYS.has(key_text)
		var valid_length = self.max_length > self.input.length()
		
		var backspace = key_text == "Backspace"
		var space = key_text == "Space"
		
		if valid_key:
			var update = self.input
			
			if backspace:
				self.handle_input_action(Action.Remove, key_text)
			elif space:
				self.handle_input_action(Action.AddSpace, key_text)
			else:
				self.handle_input_action(Action.Add, key_text)


func set_components() -> void:
	var c = Contenedor.new()
	c.layout_type = Instantiator.LayoutType.Grid
	
	## Set input underline
	var l = Element.new()
	l.background = self.color
	
	var t = Text.new()
	t.content = self.placeholder
	t.font_size = self.text_size
	t.font = load("res://static/fonts/secrcode.ttf")
	t.color = self.color
	c.add_child(t)
	c.add_child(l)
	
	self.text_display = t
	self.set_contenedor(c)
	
	## Set layout cofiguration
	c.variable_fields["layout_contenedor"]["rows"] = 7
	
	l.variable_fields["layout"]["row"] = 6
	
	t.variable_fields["layout"]["row"] = 0
	t.variable_fields["layout"]["row_span"] = 6
	
	## Set visual changes
	# Line
	l.border_radius_c = 70
	l.border_radius_d = 70
	l.margin_bottom = 70
	
	var slide_anim = BaseAnimType.set_as_animation_type(AnimationHandler.Do.Slide)
	l.animations["Focus"] = slide_anim
	
	# Text
	t.margin_top = 20
	
	var wave_anim = TextAnimationType.new()
	wave_anim.set_key(TextAnimationHandler.TextDo.find_key(TextAnimationHandler.TextDo.Wave))
	t.text_animations["Ready"] = wave_anim
	
	var appear_anim = BaseAnimType.set_as_animation_type(AnimationHandler.Do.Appear)
	t.text_animations["UnFocus"] = appear_anim
	t.text_animations["Focus"] = appear_anim


func set_contenedor(c: Contenedor):
	if self.contenedor:
		self.contenedor.queue_free()
	c.set_real_size(self.get_real_size())
	c.set_real_position(Margin.start(self))
	self.add_child.call_deferred(c)
	self.contenedor = c
	c._set_layout()


func handle_input_action(act: Action, key_text: String) -> void:
	var update = self.input
	
	match act:
		Action.Remove:
			if !self.input.is_empty():
				self.input = update.substr(0, update.length() - 1)
				
				if self.input.is_empty() and self.text_display.content != self.placeholder:
					self.text_display.content = self.placeholder
					self.trigger_wave()
				else:
					self.trigger_fly()
					await get_tree().create_timer(0.1).timeout 
					self.text_display.content = self.input
				
				self.text_display.queue_redraw()
		Action.Add:
			if self.input.is_empty() or self.input == self.placeholder:
				self.input = key_text
			else:
				self.input += key_text.to_lower()
			self.text_display.content = self.input
			self.trigger_fall()
		Action.AddSpace:
			self.input += " "
			self.text_display.content = self.input


func trigger_on_focus() -> void:
	var pop = func():
		for child in self.contenedor.get_children():
			child.animation_handler._trigger_animation("Slide", {}).call()
	
	self.connect(InputHandler.Evento.find_key(InputHandler.Evento.Focus).to_snake_case(), pop)


func trigger_wave() -> void:
	self.text_display.text_animator._trigger_animation("Wave", {}).call()


func trigger_fall() -> void:
	self.text_display.text_animator._trigger_animation("Fall", {}).call()


func trigger_fly() -> void:
	self.text_display.text_animator._trigger_animation("Fly", {}).call()


func editor_settings() -> void:
	super()
	self.set_components()
