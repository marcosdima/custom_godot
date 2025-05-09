class_name InputHandler

'''╭─[ Enums ]─────────────────────────────────────────────────────────────────────────────╮'''
enum Evento {
	MouseIn,
	MouseOut,
	ClickOn,
	ClickReleasedOn,
	Focus,
	UnFocus,
	MouseStill,
}

'''╭─[ Variables ]─────────────────────────────────────────────────────────────────────────╮'''
var element: Element

'''╭─[ Flags ]─────────────────────────────────────────────────────────────────────────────╮'''
var mouse_on = false
var click_on = false
var focus = false

'''╭─[ Lifecycle Functions ]───────────────────────────────────────────────────────────────╮'''
func _init(e: Element) -> void:
	self.element = e


'''╭─[ Methods ]───────────────────────────────────────────────────────────────────────────╮'''
func handle_input(input: InputEvent) -> void:
	if input is InputEventMouse:
		self._handle_mouse_event(input)


static func get_evento_key(e: Evento) -> String:
	return Evento.find_key(e).to_snake_case()


'''╭─[ Mouse Handlers ]────────────────────────────────────────────────────────────────────╮'''
func _handle_mouse_event(input: InputEventMouse) -> void:
	if input is InputEventMouseMotion:
		var mouse_on_element = self.element.get_area().has_point(input.position)
		if mouse_on_element and !self.mouse_on:
			self._handle_mouse_on()
			# If mouse enters with click pressed...
			if input.button_mask == MOUSE_BUTTON_LEFT:
				self._handle_click_on()
		elif !mouse_on_element and self.mouse_on:
			self._handle_mouse_out()
	elif input is InputEventMouseButton and input.button_index == MOUSE_BUTTON_LEFT:
		if input.pressed and self.mouse_on:
			self._handle_click_on()
			if !self.focus:
				self._handle_focus()
		elif input.pressed and self.focus:
			self._handle_un_focus()
		elif input.is_released() and self.mouse_on:
			self._handle_mouse_release()
			self._handle_mouse_still()


func _handle_mouse_out() -> void:
	self.mouse_on = false
	self.click_on = false
	self.element.emit(Evento.MouseOut)


func _handle_mouse_on() -> void:
	self.mouse_on = true
	self.element.emit(Evento.MouseIn)


func _handle_mouse_still() -> void:
	self.element.emit(Evento.MouseStill)


func _handle_focus() -> void:
	self.focus = true
	self.element.emit(Evento.Focus)


func _handle_un_focus() -> void:
	self.focus = false
	self.element.emit(Evento.UnFocus)


func _handle_click_on() -> void:
	self.click_on = true
	self.element.emit(Evento.ClickOn)


func _handle_mouse_release() -> void:
	self.element.emit(Evento.ClickReleasedOn)
