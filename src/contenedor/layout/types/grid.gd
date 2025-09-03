extends Layout
class_name Grid

const ROWS = "rows"
const COLUMNS = "columns"
const AUTO = "auto_row_column"

## [OVERWRITTED]
func get_default_config() -> Dictionary:
	var s = super()
	s[ROWS] = 1
	s[COLUMNS] = 1
	s[AUTO] = true
	return s


## [OVERWRITTED]
func calculate_dimensions() -> void:
	var spaces = self.get_spaces_ordered()
	var indexed_spaces = {}
	
	# Check actual rows and columns.
	var config_rows_count = contenedor.layout.config.get(ROWS, 1)
	var config_columns_count = contenedor.layout.config.get(COLUMNS, 1)
	var auto_row_column = contenedor.layout.config.get(AUTO, true)
	
	var columns_count = config_columns_count
	var rows_count = config_rows_count
	for space in self.get_spaces_ordered():
		columns_count = max(columns_count, int(space.column + 1))
		rows_count = max(rows_count, int(ceil(space.row + space.row_span)))
		
		var key = self.get_key(space.row, space.column)
		if !indexed_spaces.has(key):
			indexed_spaces.set(key, space)
	
	var cell_size = self.get_cell_size(
		rows_count if auto_row_column else config_rows_count,
		columns_count if auto_row_column else config_columns_count,
	)
	
	# Initialice rows dictionary.
	var rows = {}
	for row in range(rows_count):
		rows[row] = Vector2(0, cell_size.y * row)
	
	# Calculate sizes and positions.
	var areas = {}
	for row in range(rows_count):
		# Acc variables...
		var acc_position = rows[row]
		var max_row_high = cell_size.y
		var blank_spaces = 0
		var aux = 0.0
		
		for column in range(columns_count):
			var key = self.get_key(row, column)
			var space = indexed_spaces.get(key)
			var real_cell_size = cell_size
			
			# If row-column space exists...
			if space:
				# Update acc_position if there were blank spaces.
				if blank_spaces > 0:
					acc_position.x += real_cell_size.x * blank_spaces
					blank_spaces = 0
				
				# Get cell real size.
				var span = self.get_span(space)
				real_cell_size = cell_size * span
				
				# Save ente relative area.
				areas[space.name] = Rect2(acc_position, real_cell_size)
				
				# Update max_row_high (TODO: This actually does not work, fix later)
				max_row_high = min(max_row_high, real_cell_size.y)
				
				# Update x position.
				acc_position.x += real_cell_size.x
			else:
				blank_spaces += 1
		
		acc_position.y = max_row_high
		rows[row] = acc_position
	
	var total_size = Vector2.ZERO
	for size in rows.values():
		total_size.x = max(total_size.x, size.x)
		total_size.y += size.y 
	
	var off_set = contenedor.get_start_offset(total_size)
	for ente_key in areas:
		var area = areas[ente_key]
		area.position += off_set
		self.set_ente_area(ente_key, area)
	
	contenedor.children_handler.set_internal_size(total_size) 


## [OVERWRITTED]
func get_space() -> Space:
	return GridSpace.new()


func get_cell_size(rows_size: int = -1, columns_size:int = -1) -> Vector2:
	var area = contenedor.get_area()
	var cell_size = area.size / Vector2(
		config[COLUMNS] if columns_size < 0 else columns_size,
		config[ROWS] if rows_size < 0 else rows_size,
	)
	return cell_size


func get_span(space: GridSpace) -> Vector2:
	if !is_finite(space.row_span) or !is_finite(space.column_span):
		space.row_span = 1
		space.column_span = 1
		return Vector2(1, 1)
	
	return Vector2(space.column_span, space.row_span)


func get_key(row, column):
	return str(row) + str(column)
