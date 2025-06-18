extends Layout
class_name Grid

const ROWS = "rows"
const COLUMNS = "columns"

static func get_cell_size(c: Contenedor) -> Vector2:
	var config = Layout.get_contenedor_config(c.name)
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


func calculate_spaces(c: Contenedor) -> void:
	var spaces = SpaceManager.execute(c, SpaceManager.Action.Get)
	var cell_size = self.get_cell_size(c)

	var areas = {}
	var rows = {}
	var curr_row = Vector2.ZERO
	var spaces_size = Vector2.ZERO
	
	var rows_count = c.contenedor_config[Grid.ROWS]
	var columns_count = c.contenedor_config[Grid.COLUMNS]
	
	for r in range(rows_count):
		var blank = Vector2.ZERO
		var aux_pos = Vector2(0, r * cell_size.y)
		
		for col in range(columns_count):
			var k = str(r) + str(col)
			
			if spaces.has(k):
				var space = spaces[k]
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
				areas[k] = area
			else:
				blank += cell_size
		rows[r] = curr_row
		spaces_size.x = curr_row.x if curr_row.x > spaces_size.x else spaces_size.x
		spaces_size.y += curr_row.y
	
	var off_set = c.get_start_offset(spaces_size)
	for ente_key in areas:
		var area = areas[ente_key]
		area.position += off_set
		self.set_ente_area(c, ente_key, area)


func get_span(space: GridSpace) -> Vector2:
	if !is_finite(space.row_span) or !is_finite(space.column_span):
		space.row_span = 1
		space.column_span = 1
		return Vector2(1, 1)
	
	return Vector2(space.row_span, space.column_span)
