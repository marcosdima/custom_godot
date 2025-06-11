class_name Breader

## Set all data as default.
static func set_as_default(ente: Ente) -> void:
	ente.color = Color.TRANSPARENT
	ente.border = Border.new()
	Animator.set_animations(ente)
	
	if ente is Contenedor:
		var contenedor = ente as Contenedor
		ContenedorAnimator.set_contenedor_animations(contenedor)
		contenedor.config = {}
		contenedor.spaces = {}
		
		## This happen before layout setup.
		if contenedor is Component:
			var component = contenedor as Component
			for c in component.get_children():
				component.remove_child_def(c)
			
			component.set_default_layout_config()
			for n in component.get_contenedor_children():
				component.add_child_def(n)
			
			if component is TextInput:
				component.set_animations()
	
	Breader.check(ente)


## Routine to check and update entes.
static func check(ente: Ente) -> void:
	if ente is Contenedor:
		## Go call all its children.
		var contenedor = ente as Contenedor
		for c in contenedor.get_children():
			Breader.check(c)
		
		## Update layout.
		Layout.set_contenedor(contenedor)
		
		if contenedor is Component:
			var component = contenedor as Component
			component.set_spaces()
			
			if component is Text:
				var text = component as Text
				text.set_max_font_size()
		## Update layout.
		Layout.set_contenedor(contenedor)
	
	ente.queue_redraw()
