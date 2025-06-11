extends Animate
class_name Slide

enum Direction {
	Up,
	Down,
	Left,
	Right,
}

enum Default {
	Nothing,
	GoUp,
}

@export_group("Config")
@export var direction: Direction = Direction.Left
@export var start_at: float = 1.0 # N body sizes to the opposite direction.
@export var end_at: float = 1.0
@export var NOT_IMPLEMENTED_bounce: float = 1.0 # Not implemented.

static var save_position: Dictionary

func handle_start(e: Ente) -> void:
	var id = e.get_fosil()
	e.modulate.a = self.start_value
	Slide.save_position[id] = e.global_position
	e.global_position = self.get_start_offset(e, e.global_position)


func do(e: Ente, m: float) -> void:
	var end = Slide.save_position[e.get_fosil()]
	var start =  self.get_start_offset(e, end)
	
	var mod = start - (end)
	e.global_position = start + (mod * m * -1)
	e.modulate.a = self.end_value * m


func get_start_offset(e: Ente, start: Vector2) -> Vector2:
	var s = e.size if !self.custom_start else self.custom_start
	var offset = start
	
	match self.direction:
		Direction.Up: offset.y -= s.y * self.start_at
		Direction.Down: offset.y += s.y * self.start_at
		Direction.Right: offset.x -= s.x * self.start_at
		_: offset.x += s.x * self.start_at
	
	return offset


func get_end_offset(e: Ente) -> Vector2:
	var s = e.size if !self.custom_start else self.custom_start
	var target = self.save_position
	
	match self.direction:
		Direction.Up: target.y -= s.y * self.end_at
		Direction.Down: target.y += s.y * self.end_at
		Direction.Right: target.x -= s.x * self.end_at
		_: target.x += s.x * self.end_at
	
	return target


func set_data(dir: Direction = Direction.Left, start: float = 1, end: float = 1) -> void:
	self.direction = dir
	self.start_at = start
	self.end_at = end
