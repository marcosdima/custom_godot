extends Layout
class_name Pages


static var disappear: Animate
static var appear: Animate

func calculate_spaces(c: Contenedor) -> void:
	var sorted = Layout.get_sorted_spaces(c)
	for i in range(sorted.size()):
		Pages.handle_space(c, sorted[i], i == 0)


static func handle_space(c: Contenedor, space_key: String, first: bool) -> void:
	if !disappear or !appear:
		Pages.set_animations()
	
	var ente = c.get_ente_by_key(space_key)
	
	if first:
		Layout.set_ente_area(c, ente.name, c.get_area())
		Pages.appear.execute(ente)
	else:
		Pages.disappear.execute(ente)


static func set_animations() -> void:
	var appear_aux = Prop.new()
	appear_aux.duration = 0.2
	appear_aux.end_value = 1.0
	Pages.appear = appear_aux
	
	var dis = Prop.new()
	appear_aux.duration = 0.2
	dis.end_value = 0.0
	dis.start_value = 1.0
	Pages.disappear = dis
