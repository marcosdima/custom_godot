extends Layout
class_name Grid

@export var rows: int = 1
@export var columns: int = 1

const ROWS = "rows"
const COLUMNS = "columns"

func get_config() -> Dictionary:
	var s = super()
	s[ROWS] = self.rows
	s[COLUMNS] = self.columns
	return s


func get_new_space() -> Space:
	return GridSpace.new()


func update_spaces() -> void:
	self.rows = self.contenedor.config[ROWS]
	self.columns = self.contenedor.config[COLUMNS]
	var cell_size = self.get_cell_size()
	
	var row_size = Vector2.ZERO
	var spaces_size = Vector2.ZERO
	var areas = {}
	var rows_sizes = {}
	
	for r in range(self.rows):
		var aux_offset = Vector2(0, spaces_size.y)
		row_size = Vector2.ZERO
		
		for c in range(self.columns):
			var space_key = str(r) + str(c)
			var sub_spaces = self.contenedor.sub_spaces
			
			if sub_spaces.has(space_key):
				var area = Rect2()
				var space = sub_spaces[space_key]
				var span = Vector2(
					space.column_span if space.column_span > 0 else 1,
					space.row_span if space.row_span > 0 else 1,
				)
				
				var real_cell_size = cell_size * span
				
				row_size.x += real_cell_size.x
				row_size.y = real_cell_size.y if real_cell_size.y > row_size.y else row_size.y
				
				area.size = real_cell_size
				area.position = aux_offset
				areas[space_key] = area
				
				aux_offset.x += real_cell_size.x
		
		rows_sizes[r] = row_size
		spaces_size.x = row_size.x if row_size.x > spaces_size.x else spaces_size.x
		spaces_size.y += row_size.y
	
	var off_set = self.contenedor.get_start_offset(spaces_size)
	for ente_key in areas:
		var area = areas[ente_key]
		area.position += off_set
		self.set_ente_area(ente_key, area)


func get_cell_size() -> Vector2:
	var area = self.contenedor.get_area()
	var s = area.size / Vector2(self.contenedor.config[COLUMNS], self.contenedor.config[ROWS])
	return s
