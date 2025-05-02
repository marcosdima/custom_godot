extends AnimationHandler
class_name TextAnimationHandler

enum TextDo {
	Nothing,
	Wave,
	Fall,
	Fly,
}

var text: Text

func _init(e: Text) -> void:
	self.text = e
	self._set_animations_structure(e)
	self._element = e


func handle_connect() -> void:
	for moment in Moments.keys():
		self._element.connect(moment.to_snake_case(), self._handle_moment(Moments[moment]))


func _set_animations_structure(e: Element) -> void:
	# This set keys and default animation type. (Editor mode)
	var text_aniamtions = e.text_animations
	if text_aniamtions.is_empty() or text_aniamtions.keys().size() < Moments.keys().size():
		var aux: Dictionary = {}
		for key in Moments.keys():
			aux[key] = TextAnimationType.new()
		e.text_animations = aux


func _handle_moment(moment: Moments):
	var key = Moments.find_key(moment)
	var type = self.text.text_animations[key]
	
	if type is BaseAnimType:
		return self._trigger_animation(type.get_key(), type.settings)
	else:
		return func(): print("Invalid Resources")


'''╭─[ Animations ]───────────────────────────────────────────────────────────────────────╮'''
func _trigger_animation(key: String, settings: Dictionary):
	var do = TextDo[key] if TextDo.has(key) else -1
	
	match do:
		TextDo.Wave: return self._wave
		TextDo.Fall: return self._fall
		TextDo.Fly: return self._fly
		_: return super(key, settings)


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


func _fall():
	self.text.draw_last_char_at = 0
	self.text.draw_n_chars = self.text.content.length() - 1
	
	var _move_last_letter = func(f: float) -> void:
		self.text.draw_last_char_at = f
		self.text.queue_redraw()
		if f == 1.0:
			self.text.draw_n_chars = -1
	
	var tween = self.text.create_tween()
	tween.tween_method(_move_last_letter, 0.0, 1.0, 0.2)


func _fly():
	self.text.draw_last_char_at = 1
	self.text.draw_n_chars = self.text.content.length() - 1
	
	var _move_last_letter = func(f: float) -> void:
		self.text.draw_last_char_at = f
		self.text.queue_redraw()
		if f == 0.0:
			self.text.draw_n_chars = -1
	
	var tween = self.text.create_tween()
	tween.tween_method(_move_last_letter, 1.0, 0.0, 0.2)
