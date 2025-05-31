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


func set_space() -> Space:
	return GridSpace.new()


func update_spaces() -> void:
	self.rows = self.contenedor.config[ROWS]
	self.columns = self.contenedor.config[COLUMNS]
	
	var sorted_by_row = {}
	for r in range(self.rows):
		sorted_by_row[r] = []
		
		for s in self.get_sorted_spaces():
			if s.row == r:
				sorted_by_row[r].append(s)
				sorted_by_row[r].sort_custom(func(a, b): return a.column < b.column)
	
	var last_r = 0
	var last_start = Vector2.ZERO
	var s = get_cell_size()
	
	for r in sorted_by_row.keys():
		last_r = int(r)
		last_start = Vector2(0, s.y * last_r)
		
		for space in sorted_by_row[r]:
			var column_blank = space.row - last_r
			var pos = last_start + Vector2(s.x * column_blank, 0)
			var size_sp = s * Vector2(space.column_span, space.row_span)
			
			self.set_ente_area(space, Rect2(pos, size_sp))
			last_start.x += size_sp.x


func get_cell_size() -> Vector2:
	var area = self.contenedor.get_area()
	var s = area.size / Vector2(self.rows, self.columns)
	return s
