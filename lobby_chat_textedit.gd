extends TextEdit

signal send_current_message

func _ready() -> void:
	connect("send_current_message", Callable.create(get_tree().get_current_scene(), "_on_send_msg_button_pressed"))

func _gui_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_ENTER:
				# Allow Shift + Enter to insert a newline
				if event.shift_pressed:
					insert_text_at_caret("\n")
				# Handle Enter key without Shift
				else:
					accept_event()
					send_current_message.emit()
			KEY_SHIFT:
				pass
