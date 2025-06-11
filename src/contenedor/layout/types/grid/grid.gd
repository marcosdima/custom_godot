extends Layout
class_name Grid

const ROWS = "rows"
const COLUMNS = "columns"

func get_config() -> Dictionary:
	var s = super()
	s[ROWS] = 1
	s[COLUMNS] = 1
	return s


func get_new_space() -> Space:
	return GridSpace.new()


func calculate_spaces(c: Contenedor) -> void:
	var rows = c.config[ROWS]
	var columns = c.config[COLUMNS]
	var cell_size = Grid.get_cell_size(c)
	
	var row_size = Vector2.ZERO
	var spaces_size = Vector2.ZERO
	var areas = {}
	var rows_sizes = {}
	
	for row in range(rows):
		var aux_offset = Vector2(0, spaces_size.y)
		row_size = Vector2.ZERO
		
		for col in range(columns):
			var space_key = str(row) + str(col)
			var spaces = c.spaces
			
			if spaces.has(space_key):
				var area = Rect2()
				var space = spaces[space_key] as GridSpace
				var span = Grid.get_span(space)
				
				var real_cell_size = cell_size * span
				
				row_size.x += real_cell_size.x
				row_size.y = real_cell_size.y if real_cell_size.y > row_size.y else row_size.y
				
				area.size = real_cell_size
				area.position = aux_offset
				areas[space_key] = area
				
				aux_offset.x += real_cell_size.x
		
		rows_sizes[row] = row_size
		spaces_size.x = row_size.x if row_size.x > spaces_size.x else spaces_size.x
		spaces_size.y += row_size.y
	
	var off_set = c.get_start_offset(spaces_size)
	for ente_key in areas:
		var area = areas[ente_key]
		area.position += off_set
		Layout.set_ente_area(c, ente_key, area)


static func get_cell_size(c: Contenedor) -> Vector2:
	var area = c.get_area()
	var s = area.size / Vector2(c.config[COLUMNS], c.config[ROWS])
	return s


static func get_span(space: GridSpace) -> Vector2:
	if !is_finite(space.row_span) or !is_finite(space.column_span):
		return Vector2(1, 1)
	
	return Vector2(space.row_span, space.column_span)
