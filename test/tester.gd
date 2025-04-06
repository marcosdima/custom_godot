extends Control

func _on_screen_clicked() -> void:
	print("Click on screen!")


func _on_screen_mouse_on() -> void:
	print("Mouse on screen!")


func _on_button_pressed() -> void:
	print("Size: ", $Screen/FlowContainer/Button.size, " Position: ", $Screen/FlowContainer/Button.position)
