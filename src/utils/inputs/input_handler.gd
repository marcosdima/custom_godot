class_name InputHandler

var ente: Ente
var data: InputData = InputData.new()
var ente_real_area: Rect2

var mouse_on = false
var click_on = false
var focus = false

func _init(e: Ente) -> void:
	ente = e


func handle_input(input: InputEvent) -> void:
	ente_real_area = Rect2(ente.global_position, ente.size)
	if input is InputEventMouse:
		self._handle_mouse_event(input)
	#TOFIX: Maybe this has to be handled in an static way.
	elif input is InputEventKey:
		self._handle_key_event(input)


static func get_evento_key(e: Ente.Event) -> String:
	return Ente.Event.find_key(e).to_snake_case()


'''╭─[ Mouse handlers ]─────────────────────────────────────────────────────────────────────────╮'''
func _handle_mouse_event(input: InputEventMouse) -> void:
	if input is InputEventMouseMotion:
		var mouse_on_ente = ente_real_area.has_point(input.position)
		if mouse_on_ente and !self.mouse_on:
			self._handle_mouse_on()
			# If mouse enters with click pressed...
			if input.button_mask == MOUSE_BUTTON_LEFT:
				self._handle_click_on()
		elif !mouse_on_ente and self.mouse_on:
			self._handle_mouse_out()
	elif input is InputEventMouseButton and input.button_index == MOUSE_BUTTON_LEFT:
		if input.pressed and self.mouse_on:
			self._handle_click_on()
		elif input.pressed and self.focus:
			self._handle_un_focus()
		elif input.is_released() and self.mouse_on:
			self._handle_mouse_release()
			if !self.focus:
				self._handle_focus()
			self._handle_mouse_still()


func _handle_mouse_out() -> void:
	self.mouse_on = false
	self.click_on = false
	self.ente.emit(Ente.Event.MouseOut)


func _handle_mouse_on() -> void:
	self.mouse_on = true
	self.ente.emit(Ente.Event.MouseIn)


func _handle_mouse_still() -> void:
	self.ente.emit(Ente.Event.MouseStill)


func _handle_focus() -> void:
	self.focus = true
	self.ente.emit(Ente.Event.OnFocus)


func _handle_un_focus() -> void:
	self.focus = false
	self.ente.emit(Ente.Event.OnUnfocus)


func _handle_click_on() -> void:
	self.click_on = true
	self.ente.emit(Ente.Event.OnClick)


func _handle_mouse_release() -> void:
	self.ente.emit(Ente.Event.OnClickReleased)


'''╭─[ Key Handlers ]─────────────────────────────────────────────────────────────────────────╮'''
func _handle_key_event(input: InputEventKey) -> void:
	var new_data = InputData.new()
	var unicode = input.unicode
	
	var letter = (unicode >= 65 and unicode <= 90) or (unicode >= 97 and unicode <= 122)
	var numeric = unicode >= 48 and unicode <= 57
	var is_char = unicode >= 32 and unicode <= 0x10FFFF
	
	new_data.is_letter = letter
	new_data.is_numeric = numeric
	new_data.is_sign = !letter and !numeric and is_char
	if letter or numeric or is_char:
		new_data.set_key(char(unicode))
	else:
		new_data.set_action(input.as_text_keycode())
	
	data = new_data
