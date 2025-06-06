extends Animate
class_name Slide

enum Orientation {
	Up,
	Down,
	Left,
	Right,
}

@export var direction: Slide.Orientation = Slide.Orientation.Left
@export var start_at: float = 1.0 # N body sizes to the opposite direction.
@export var NOT_IMPLEMENTED_bounce: float = 1.0 # Not implemented.

static var save_position: Dictionary = {}

func handle_start(e: Ente) -> void:
	e.modulate.a = 0.0
	var id = e.get_instance_id()
	if !self.save_position.has(id):
		self.save_position[id] = e.global_position
	e.global_position = self.get_offset(e)


func get_offset(e: Ente) -> Vector2:
	var s = e.size
	var offset = e.global_position
	
	match self.direction:
		Orientation.Up: offset.y -= s.y * self.start_at
		Orientation.Down: offset.y += s.y * self.start_at
		Orientation.Right: offset.x -= s.x * self.start_at
		_: offset.x += s.x * self.start_at
	
	return offset


static func get_save_position(e: Ente) -> Vector2:
	return save_position[e.get_instance_id()]
