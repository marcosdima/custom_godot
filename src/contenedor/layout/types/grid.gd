extends Layout
class_name Grid

const ROWS = "rows"
const COLUMNS = "columns"


## [OVERWRITTED]
func get_default_config() -> Dictionary:
	var s = super()
	s[ROWS] = 1
	s[COLUMNS] = 1
	return s


## [OVERWRITTED]
func calculate_dimensions() -> void:
	var cell_size = self.get_cell_size()
	var coord_spaces = {}
	var areas = {}
	var rows = {}
	
	## Takes rows count
	var rows_count = contenedor.layout.config[Grid.ROWS]
	var columns_count = contenedor.layout.config[Grid.COLUMNS]
	for space in self.get_spaces_ordered():
		var col = space.column + 1
		var row = space.row + 1
		
		if col > columns_count:
			columns_count = col
		if row > rows_count:
			rows_count = row
		
		var key = self.get_key(space.row, space.column)
		if !coord_spaces.has(key):
			coord_spaces.set(key, space)
	
	var curr_row = Vector2.ZERO
	for row in range(rows_count):
		var max_row_height = 0.0
		var row_blank_space = 0.0
		
		for col in range(columns_count):
			var key = self.get_key(row, col)
			var space = coord_spaces.get(key)
			
			if space:
				# Get cell real size.
				var span = self.get_span(space)
				var real_cell_size = cell_size * span
				
				# Save ente relative area.
				var area = Rect2()
				area.position = curr_row
				area.size = real_cell_size
				areas[space.name] = area
				
				# Update acc variables.
				curr_row.x += real_cell_size.x + row_blank_space
				if real_cell_size.y > max_row_height:
					max_row_height = real_cell_size.y
				row_blank_space = 0
			else:
				row_blank_space += cell_size.x
		
		curr_row.y += max_row_height if max_row_height > 0 else cell_size.y
		rows[row] = curr_row
		curr_row.x = 0 
	
	var total_size = Vector2.ZERO
	for size in rows.values():
		total_size.x = max(total_size.x, size.x)
		total_size.y = max(total_size.y, size.y)
	
	var off_set = contenedor.get_start_offset(total_size)
	for ente_key in areas:
		var area = areas[ente_key]
		area.position += off_set
		self.set_ente_area(ente_key, area)
	
	contenedor.children_handler.set_internal_size(total_size) 


## [OVERWRITTED]
func get_space() -> Space:
	return GridSpace.new()


func get_span(space: GridSpace) -> Vector2:
	if !is_finite(space.row_span) or !is_finite(space.column_span):
		space.row_span = 1
		space.column_span = 1
		return Vector2(1, 1)
	
	return Vector2(space.column_span, space.row_span)


func get_cell_size(rows_size: int = -1, columns_size:int = -1) -> Vector2:
	var area = contenedor.get_area()
	
	var s = area.size / Vector2(
		config[COLUMNS] if columns_size < 0 else columns_size,
		config[ROWS] if rows_size < 0 else rows_size,
	)
	return s


func get_key(row, column):
	return str(row) + str(column)
