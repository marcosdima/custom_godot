class_name Animator

enum Animations {
	Pop,
	Modulate,
}

static func set_animations(e: Ente) -> void:
	if !e.animations or e.animations.is_empty():
		var aux = {}
		for event_value in Ente.Event.values():
			var event_key = Ente.Event.find_key(event_value)
			var animate = AnimateWrapper.new()
			aux[event_key.to_snake_case()] = animate
		e.animations = aux


static func connect_animator(e: Ente) -> void:
	for event in e.animations.keys():
		var wrapper = e.animations[event] as AnimateWrapper
		if wrapper.animate:
			e.connect_event(
					Ente.Event[event.to_pascal_case()],
					func():
						var anim = wrapper.animate
						anim.handle_start(e)
						anim.execute(e)
			)
