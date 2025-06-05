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
		var aux_animations = e.animations
		e.connect_event(
			Ente.Event[event.to_pascal_case()],
			func():
				if aux_animations.has(event):
					Animator.do(e, aux_animations[event].animate)
				else:
					printerr("Missing: ", event, " at animations.")
		)


static func do(e: Ente, this: Animate) -> void:
	if !this:
		return
	
	if this is Modulate:
		Animator._modulate(e, this)
	elif this is Slide:
		Animator._slide(e, this)
	elif not this is Animate:
		print("Animate type [", this, "] not found. Code: ", typeof(this), ". At: ", e)


static func _modulate(e: Ente, this: Modulate):
	this.handle_start(e)
	var tween = e.create_tween()
	tween.tween_property(e, "modulate:a", this.end, this.duration)


static func _slide(e: Ente, this: Slide):
	this.handle_start(e)
	e.modulate.a = 1.0
	var tween = e.create_tween()
	tween.tween_property(e, "global_position", Slide.save_position[e.name], this.duration)
