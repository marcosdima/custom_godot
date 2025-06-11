class_name ContenedorAnimator

enum AnimationsC {
	Simple,
}

static func set_contenedor_animations(c: Contenedor) -> void:
	if !c.contenedor_animations or c.contenedor_animations.is_empty():
		var aux = {}
		for event_value in Ente.Event.values():
			var event_key = Ente.Event.find_key(event_value)
			var animate = AnimateContenedor.new()
			aux[event_key.to_snake_case()] = animate
		c.contenedor_animations = aux
	
	if !Engine.is_editor_hint():
		ContenedorAnimator.connect_contenedor_animator(c)


static func connect_contenedor_animator(c: Contenedor) -> void:
	for event in c.contenedor_animations.keys():
		var animate_c = c.contenedor_animations[event] as AnimateContenedor
		if animate_c.animate_wrapper.animate:
			c.connect_event(
					Ente.Event[event.to_pascal_case()],
					func():
						ContenedorAnimator.do(c, animate_c)
			)


static func do(c: Contenedor, this: AnimateContenedor) -> void:
	match this.do:
		AnimationsC.Simple: ContenedorAnimator._simple(c, this)
		_: pass


static func _simple(c: Contenedor, animate_c: AnimateContenedor) -> void:
	var spaces_keys = Layout.get_sorted_spaces(c)
	var animate_base = animate_c.animate_wrapper.animate
	
	if animate_base.active:
		return
	animate_base.custom_start = c.get_area().position
	animate_base.lock()
	
	var animate_indv = {}
	for k in spaces_keys:
		var animate = animate_base.duplicate()
		var ente = c.get_ente_by_key(k)
		animate.handle_start(ente)
		animate_indv[k] = animate
	
	await c.get_tree().create_timer(animate_c.delay).timeout
	for k in spaces_keys:
		animate_indv[k].execute(c.get_ente_by_key(k))
		await c.get_tree().create_timer(animate_c.delay).timeout
	
	animate_base.unlock()
