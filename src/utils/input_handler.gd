class_name InputHandler

const KEY = "key"

var ente: Ente
var data = {}

var mouse_on = false
var click_on = false
var focus = false

func _init(e: Ente) -> void:
	self.ente = e


func handle_input(input: InputEvent) -> void:
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
		var mouse_on_ente = self.ente.get_area().has_point(input.position)
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
	var unicode = input.unicode
	if  input.unicode < 1000 and unicode > 0:
		var new_data = {
			KEY: char(unicode),
		}
		self.data = new_data
