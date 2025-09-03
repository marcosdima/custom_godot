extends Resource
class_name Parasite

signal released
var host: Ente

## [OVERWRITE] Validate e as a posible parasite host candidate.
func valid_ente() -> bool:
	return host.body is Ente


## [OVERWRITE] What this parasite does.
func activate() -> void:
	pass


## Body was release from this parasite.
func release() -> void:
	self.emit_signal("released")


## Set a timer.
func set_timeout(time: float) -> void:
	await host.get_tree().create_timer(time).timeout
