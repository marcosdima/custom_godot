extends Layout
class_name Grid

const ROWS = "rows"
const COLUMNS = "columns"

var rows = {}

## [OVERWRITTED]
func get_default_config() -> Dictionary:
	var s = super()
	s[ROWS] = 1
	s[COLUMNS] = 1
	return s


## [OVERWRITTED]
func calculate_dimensions() -> void:
	var spaces_values = spaces.values() as Array
	var areas = {}
	rows = {}
	
	## Takes rows count
	var rows_count = contenedor.layout.config[Grid.ROWS]
	var columns_count = contenedor.layout.config[Grid.COLUMNS]
	for space in spaces_values:
		var col = space.column + 1
		var row = space.row + 1
		if col > columns_count:
			columns_count = col
		if row > rows_count:
			rows_count = row
	var cell_size = self.get_cell_size()
	
	var f = func(r, col):
		for s in spaces_values:
			var space = s as GridSpace
			if space.row == r and space.column == col:
				return space
	
	var curr_row = Vector2.ZERO
	for r in range(rows_count):
		var max_row_height = 0.0
		
		for col in range(columns_count):
			var space = f.call(r, col)
			if space:
				var span = self.get_span(space)
				var real_cell_size = cell_size * span
				
				if real_cell_size.y > max_row_height:
					max_row_height = real_cell_size.y
				
				# Save ente relative area.
				var area = Rect2()
				area.position = curr_row
				area.size = real_cell_size
				areas[space.name] = area
				
				curr_row.x += real_cell_size.x
			else:
				curr_row.x += cell_size.x
		
		curr_row.y += max_row_height if max_row_height > 0 else cell_size.y
		rows[r] = curr_row
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
	
	contenedor.custom_minimum_size = total_size


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
