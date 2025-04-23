class_name InputHandler

'''╭─[ Enums ]─────────────────────────────────────────────────────────────────────────────╮'''
enum Evento {
	MouseIn,
	MouseOut,
	ClickOn,
	ClickReleasedOn
}

'''╭─[ Variables ]─────────────────────────────────────────────────────────────────────────╮'''
var element: Element

'''╭─[ Flags ]─────────────────────────────────────────────────────────────────────────────╮'''
var mouse_on = false
var click_on = false

'''╭─[ Lifecycle Functions ]───────────────────────────────────────────────────────────────╮'''
func _init(e: Element) -> void:
	self.element = e


'''╭─[ Methods ]───────────────────────────────────────────────────────────────────────────╮'''
func handle_input(input: InputEvent) -> void:
	if input is InputEventMouse:
		self._handle_mouse_event(input)


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
	elif input is InputEventMouseButton and input.button_index == MOUSE_BUTTON_LEFT and self.mouse_on:
		if input.pressed:
			self._handle_click_on()
		elif input.is_released():
			self._handle_mouse_release()
			self._handle_mouse_on()


func _handle_mouse_on() -> void:
	self.mouse_on = true
	self.element.emit(Evento.MouseIn)


func _handle_mouse_out() -> void:
	self.mouse_on = false
	self.click_on = false
	self.element.emit(Evento.MouseOut)


func _handle_click_on() -> void:
	self.click_on = true
	self.element.emit(Evento.ClickOn)


func _handle_mouse_release() -> void:
	self.element.emit(Evento.ClickReleasedOn)
