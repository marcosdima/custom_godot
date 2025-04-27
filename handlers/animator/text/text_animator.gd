extends Node
class_name TextAnimationHandler

enum Moments {
	Ready,
	ReleasedOn,
}

enum TextDo {
	Nothing,
	Appear,
	Wave,
}

var text: Text

func _init(e: Text) -> void:
	self.text = e
	self._set_animations_structure()
	
	self.text.connect('ready', self._handle_moment(Moments.Ready))
	self.text.connect(
		self.get_key(InputHandler.Evento.ClickReleasedOn), 
		self._handle_moment(Moments.ReleasedOn)
	)


func get_key(e: InputHandler.Evento) -> String:
	return InputHandler.Evento.find_key(e).to_snake_case()


func _set_animations_structure() -> void:
	# This set keys and default animation type. (Editor mode)
	var text_aniamtions = self.text.text_animations
	if text_aniamtions.is_empty() or text_aniamtions.keys().size() < Moments.keys().size():
		var aux: Dictionary = {}
		for key in Moments.keys():
			aux[key] = TextAnimationType.new()
		self.text.text_animations = aux


func _handle_moment(moment: Moments):
	var key = Moments.find_key(moment)
	var anim_do = self.text.text_animations[key].do
	return self._trigger_animation(anim_do)


'''╭─[ Animations ]───────────────────────────────────────────────────────────────────────╮'''
func _trigger_animation(do: TextDo):
	match do:
		TextDo.Appear: return self._appear
		TextDo.Wave: return self._wave
		_: return func(): return


func _appear():
	var _modify = func(f: float) -> void:
		self.text.color.a = f
		self.text.queue_redraw()
	var tween = self.text.create_tween()
	self.text.color.a = 0.0
	tween.tween_method(_modify, 0.0, 1.0, 0.5)


func _wave():
	self.text.draw_last_char_at = 0
	self.text.draw_n_chars = 0
	
	var tween = self.text.create_tween()
	
	for i in self.text.content.length():
		tween.tween_callback(func():
			self.text.draw_n_chars = i + 1
			self.text.draw_last_char_at = 0.0
			self.text.queue_redraw()
		)
	
		var _move_last_letter = func(f: float) -> void:
			self.text.draw_last_char_at = f
			self.text.queue_redraw()
	
		tween.tween_method(_move_last_letter, 0.0, 1.0, 0.05)
