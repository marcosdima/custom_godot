class_name ManualTimer

var time_left: float = 0.0
var duration: float = 0.0

var running: bool = false
var repeat: bool = false
var _stopped: bool = false

var callback: Callable = func(): return

func _init(
	duration_in_seconds: float = 0.0,
	cb: Callable = func(): return,
	repeat_: bool = false,
) -> void:
	duration = duration_in_seconds
	callback = cb
	repeat = repeat_


func start() -> void:
	# Check if is currently running or it was stopped.
	if !running and !_stopped:
		running = true
		time_left = duration
		self._process_tick()
	elif _stopped:
		_stopped = false


func stop() -> void:
	_stopped = true
	running = false
	time_left = 0.0


func _process_tick() -> void:
	if !running:
		return
	
	# Wait for the next frame
	await Engine.get_main_loop().process_frame
	
	# Decrease time
	time_left -= Engine.get_main_loop().root.get_process_delta_time()
	
	# Cycle ends...
	if time_left <= 0:
		# Sets running as false.
		running = false
		
		# Calls callback callable.
		callback.call()
		
		# If repeat is true, then restart
		if repeat:
			self.start()
	else:
		self._process_tick()
