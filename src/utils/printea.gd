class_name Printea

const ENTER = "\n"
const TAB = "\t"

static func print(e: Ente, msg="") -> void:
	print("Message: " + msg if msg != "" else msg)
	if e is Component:
		Printea.print_component(e)
	elif e is Contenedor:
		Printea.print_contenedor(e)
	else:
		Printea.print_ente(e)


static func print_space(full: int = 100, fill: String ="", separator: String = "-") -> void:
	var L = 50
	
	@warning_ignore("integer_division")
	var real_l: int = (L * full) / 100
	@warning_ignore("integer_division")
	var spaces: int = (L - real_l) / 2
	
	var aux = ""
	var flag = false
	for i in range(L):
		if i < spaces or i > (L - spaces - fill.length()):
			aux += " "
		else:
			if flag:
				aux += separator
			else:
				aux += fill
				flag = true
	
	print(aux)


'''╭─[ Ente ]─────────────────────────────────────────────────────────────────────────╮'''
static func print_ente(e, extra_fields: Dictionary = {}) -> void:
	print(Printea.get_ente_data(e))
	for value in extra_fields:
		print(TAB + "- ", value, ": ", extra_fields[value])
	print()
	Printea.print_space()


static func print_contenedor(c: Contenedor, extra_fields: Dictionary = {}) -> void:
	var aux = extra_fields
	var children = ENTER
	for child in c.get_children():
		children += Printea.get_ente_data(child, 2)
	aux['Spaces'] = c.spaces
	aux['Layout'] = Layout.LayoutType.find_key(c.get_layout_type())
	aux['Children'] = children
	Printea.print_ente(c, aux)


static func print_component(c: Component, extra_fields: Dictionary = {}) -> void:
	var aux = extra_fields
	
	aux['Default children'] = c.get_contenedor_children()
	Printea.print_contenedor(c, aux)


static func get_ente_data(e: Ente, tabs_count: int = 0) -> String:
	var data = ""
	var tabs = Printea.get_tabs(tabs_count)
	data += tabs + e.name + ': ' + ENTER
	data += tabs + TAB + '- Size: ' + str(e.size) + ENTER
	data += tabs + TAB + '- Pos: ' + str(e.global_position) + ENTER
	data += tabs + TAB + '- Color: ' + str(e.color) + ENTER
	data += tabs + TAB + '- Visible: ' + str(e.visible) + ENTER
	return data


static func get_tabs(n: int) -> String:
	var aux = ""
	for i in range(n):
		aux += TAB
	return aux


'''╭─[ Event ]─────────────────────────────────────────────────────────────────────────╮'''
static func print_event(e: InputEvent) -> void:
	print("Event raw: ", e.as_text())
	print("It was: " + "Pressed" if e.is_pressed() else "Released")
	
	if e is InputEventKey:
		var t = TAB + TAB
		var unicode =  e.unicode
		
		if unicode < 1000 and unicode > 0:
			print()
			Printea.print_space(80, "Values ")
			print(t + "Real code: ", unicode)
			print(t + "Real value: ", char(unicode))
			print()
	Printea.print_space()
