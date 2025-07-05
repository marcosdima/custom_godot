@tool
extends Wrapper
class_name Boton

var flag_last: bool = false ## TODO: Fix... it should not be handled like this.

var hover_l: float = 0.5
var click_l: float = 0.4

var appear: Prop
var disappear: Prop

var aux_color: Color

func _ready() -> void:
	super()
	self.set_animations()
	self.aux_color = self.background_color
	self.connect_event(Ente.Event.MouseIn, self._on_mouse_in)
	self.connect_event(Ente.Event.MouseStill, self._on_mouse_in)
	self.connect_event(Ente.Event.MouseOut, self._on_mouse_out)
	self.connect_event(Ente.Event.OnClick, self._on_click_on)
	self.connect_event(Ente.Event.OnClickReleased, self._on_mouse_released_on)


func _get_color_l(color: Color, l: float) -> Color:
	if color == Color.TRANSPARENT:
		return color
	
	return Color.from_hsv(color.h, color.s, l)


func set_animations() -> void:
	var appear_aux = Prop.new()
	appear_aux.duration = 0.2
	appear_aux.end_value = 1.0
	self.appear = appear_aux
	
	var dis = Prop.new()
	dis.duration = 0.2
	dis.end_value = 0.0
	dis.start_value = 1.0
	self.disappear = dis


## Handle MouseIn Evento.
func _on_mouse_in() -> void:
	self.background_color = self._get_color_l(self.aux_color, self.hover_l)


## Handle MouseOut Evento.
func _on_mouse_out() -> void:
	self.background_color = self.aux_color


## Handle ClickOn Evento.
func _on_click_on() -> void:
	self.background_color = self._get_color_l(self.aux_color, self.click_l)


## Handle ClickReleasedOn Evento.
func _on_mouse_released_on() -> void:
	self.background_color = self.aux_color
	self.disappear.execute(self, func(): self.modulate.a = 1)
