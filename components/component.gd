@tool
extends Element
class_name Component

'''╭─[ Export Variables ]──────────────────────────────────────────────────────────────────╮'''
@export var color: Color = Color.TRANSPARENT

'''╭─[ Variables ]─────────────────────────────────────────────────────────────────────────╮'''
var aux_color: Color
var hover_l: float = 0.5
var click_l: float = 0.4

'''╭─[ Lifecycle Functions ]───────────────────────────────────────────────────────────────╮'''
func _ready() -> void:
	super()
	self.aux_color = self.color


'''╭─[ Setters and Getters ]───────────────────────────────────────────────────────────────╮'''
func _get_color_l(l: float) -> Color:
	if self.aux_color == Color.TRANSPARENT:
		return self.aux_color
	
	return Color.from_hsv(self.aux_color.h, self.aux_color.s, l)


'''╭─[ Methods ]───────────────────────────────────────────────────────────────────────────╮'''
func emit(e: InputHandler.Evento) -> void:
	super(e)
	match e:
		InputHandler.Evento.MouseIn: self._on_mouse_in()
		InputHandler.Evento.MouseStill: self._on_mouse_in()
		InputHandler.Evento.MouseOut: self._on_mouse_out()
		InputHandler.Evento.ClickOn: self._on_click_on()
		InputHandler.Evento.ClickReleasedOn: self._on_mouse_released_on()
	self.queue_redraw()


## Handle MouseIn Evento.
func _on_mouse_in() -> void:
	self.color = self._get_color_l(self.hover_l)


## Handle MouseOut Evento.
func _on_mouse_out() -> void:
	self.color = self.aux_color


## Handle ClickOn Evento.
func _on_click_on() -> void:
	self.color = self._get_color_l(self.click_l)


## Handle ClickReleasedOn Evento.
func _on_mouse_released_on() -> void:
	self.color = self.aux_color
