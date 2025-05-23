extends Node
class_name AnimationHandler

enum Moments {
	Ready,
	ClickReleasedOn,
	ClickOut,
	Focus,
	UnFocus,
	Trigger,
}

enum Do {
	Nothing,
	Appear,
	Slide,
	Pop,
}

var _element: Element
var resize_pos: Vector2 = Vector2.ZERO
var resize_size: Vector2 = Vector2.ZERO

func _init(e: Element) -> void:
	self._element = e
	self._set_animations_structure(e)


func handle_connect() -> void:
	for moment in Moments.keys():
		self._element.connect(moment.to_snake_case(), self._handle_moment(Moments[moment]))


func _set_animations_structure(e: Element) -> void:
	# This set keys and default animation type. (Editor mode)
	if e.animations.is_empty():
		var aux: Dictionary = {}
		for key in Moments.keys():
			aux[key] = AnimationType.new()
		e.set_animations(aux)


func _handle_moment(moment: Moments):
	var key = Moments.find_key(moment)
	var type = self._element.animations[key]
	return self._trigger_animation(type.get_key(), type.settings)


'''╭─[ Animations ]───────────────────────────────────────────────────────────────────────╮'''
func _trigger_animation(key: String, settings: Dictionary):
	var do = Do[key]
	
	match do:
		Do.Appear: return self._appear
		Do.Pop: return self._pop
		Do.Slide: 
			if settings.has('direction'):
				return func(): self._slide(settings['direction'])
			else:
				return func(): self._slide('up')
		_: return func(): return


func _appear():
	self._element.modulate.a = 0.0
	var tween = self._element.create_tween()
	tween.tween_property(self._element, "modulate:a", 1.0, 1.0)


func _slide(direction: String):
	# Multiplier for the movement (10% of size)
	var movement_strength = 0.7
	var real_size = self._element.size
	var offset = Vector2.ZERO
	
	## TODO: Animation settings.
	match direction.to_lower():
		"up":
			offset.y = real_size.y * movement_strength
		"down":
			offset.y = -real_size.y * movement_strength
		"left":
			offset.x = real_size.x * movement_strength
		"right":
			offset.x = -real_size.x * movement_strength
		_:
			push_warning("Invalid direction: %s" % direction)
	
	var _move_back = func(f: float) -> void:
		var new_size = real_size + (offset * f)
		self._element.set_real_size(new_size)
	
	var tween = self._element.create_tween()
	tween.tween_method(_move_back, 1.0, 0.0, 0.2)
	self._element.queue_redraw()


func _pop():
	var element_size = self._element.size
	var element_position = self._element.position
	
	var init_size = element_size * 0.70
	var diff = element_size - init_size
	
	var tween = self._element.create_tween()
	
	self._element.size = init_size
	self._element.position += (diff / 2)
	var duration = 0.1
	tween.parallel().tween_property(self._element, "size", element_size, duration)
	tween.parallel().tween_property(self._element, "position", element_position, duration)
