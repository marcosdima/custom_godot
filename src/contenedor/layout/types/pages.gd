extends Layout
class_name Pages

var on_page: int = 0:
	set(value):
		var pages_count = self.contenedor.contenedor_spaces.size()
		
		if value < 0:
			on_page = pages_count - 1
		elif value >= pages_count:
			on_page = 0
		else:
			on_page = value

func calculate_spaces() -> void:
	var sorted = self.contenedor.get_spaces_ordered()
	for i in range(sorted.size()):
		self.handle_space(sorted[i], i == self.on_page)


func handle_space(space: Space, first: bool) -> void:
	var c = self.contenedor
	var ente = c.get_ente_by_key(c.contenedor_spaces.find_key(space))
	
	if first:
		self.set_ente_area(ente.get_name(), c.get_area())
		ente.visible = true
	else:
		ente.visible = false

'''
static func set_animations() -> void:
	var appear_aux = Prop.new()
	appear_aux.duration = 0.2
	appear_aux.end_value = 1.0
	Pages.appear = appear_aux
	
	var dis = Prop.new()
	appear_aux.duration = 0.2
	dis.end_value = 0.0
	dis.start_value = 1.0
	Pages.disappear = dis'''
