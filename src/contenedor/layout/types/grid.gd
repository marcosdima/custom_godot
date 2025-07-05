extends Layout
class_name Grid

const ROWS = "rows"
const COLUMNS = "columns"

func get_cell_size() -> Vector2:
	var c = self.contenedor
	var area = c.get_area()
	var s = area.size / Vector2(config[COLUMNS], config[ROWS])
	return s


## [OVERWRITE] Returns the configuration necessary for this layout.
func get_default_config() -> Dictionary:
	var s = super()
	s[ROWS] = 1
	s[COLUMNS] = 1
	return s


func get_new_space() -> Space:
	return GridSpace.new()


func calculate_spaces() -> void:
	var c = self.contenedor
	var spaces = c.contenedor_spaces
	var spaces_values = spaces.values() as Array
	var cell_size = self.get_cell_size()

	var areas = {}
	var rows = {}
	var curr_row = Vector2.ZERO
	var spaces_size = Vector2.ZERO
	#print(c.contenedor_config, c.name)
	var rows_count = c.contenedor_config[Grid.ROWS]
	var columns_count = c.contenedor_config[Grid.COLUMNS]
	
	var f = func(r, col):
		for s in spaces_values:
			if s.row == r and s.column == col:
				return s
		return null
	
	for r in range(rows_count):
		var blank = Vector2.ZERO
		var aux_pos = Vector2(0, r * cell_size.y)
		
		for col in range(columns_count):
			var space_finded = f.call(r, col)
			
			if space_finded:
				var space = space_finded
				var span = self.get_span(space)
				
				var real_cell_size = cell_size * span
				curr_row.x += real_cell_size.x
				if real_cell_size.y > curr_row.y:
					curr_row.y = real_cell_size.y
				
				# Save ente relative area.
				var area = Rect2()
				area.position = aux_pos
				area.size = real_cell_size
				aux_pos.x += real_cell_size.x + blank.x
				blank = Vector2.ZERO
				areas[spaces.find_key(space)] = area
			else:
				blank += cell_size
		rows[r] = curr_row
		spaces_size.x = curr_row.x if curr_row.x > spaces_size.x else spaces_size.x
		spaces_size.y += curr_row.y
	
	var off_set = c.get_start_offset(spaces_size)
	for ente_key in areas:
		var area = areas[ente_key]
		area.position += off_set
		self.set_ente_area(ente_key, area)


func get_span(space: GridSpace) -> Vector2:
	if !is_finite(space.row_span) or !is_finite(space.column_span):
		space.row_span = 1
		space.column_span = 1
		return Vector2(1, 1)
	
	return Vector2(space.column_span, space.row_span)
