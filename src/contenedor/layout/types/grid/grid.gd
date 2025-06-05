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
	var our_contenedor = self.contenedor
	var sub_spaces = our_contenedor.sub_spaces
	var cell_size = self.get_cell_size()
	var contenedor_start = our_contenedor.get_area().position
	
	var aux_start = contenedor_start
	var aux_y = 0
	for r in range(self.rows):
		aux_start.y = contenedor_start.y + (aux_y * r)
		aux_start.x = contenedor_start.x
		
		for c in range(self.columns):
			var space_key = str(r) + str(c)
			
			if our_contenedor.sub_spaces.has(space_key):
				var space = our_contenedor.sub_spaces[space_key] as GridSpace
				
				var span = Vector2(
					space.column_span if space.column_span > 0 else 1,
					space.row_span if space.row_span > 0 else 1
				)
				var real_cell_size = cell_size * span
				
				if real_cell_size > Vector2.ZERO:
					self.set_ente_area(space_key, Rect2(aux_start, real_cell_size))
				aux_start.x += real_cell_size.x
				aux_y = real_cell_size.y


func get_cell_size() -> Vector2:
	var area = self.contenedor.get_area()
	var s = area.size / Vector2(self.contenedor.config[COLUMNS], self.contenedor.config[ROWS])
	return s
