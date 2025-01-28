extends Node2D

var console
var document
var window
var Promise

func _ready():
	if !OS.has_feature('web'):
		print("Test must be run on Web export")
		return

	console = JavaScriptBridge.get_interface("console")
	document = JavaScriptBridge.get_interface("document")
	window = JavaScriptBridge.get_interface("window")
	Promise = JavaScriptBridge.get_interface("Promise")




func _on_download_button():
	if !OS.has_feature('web'):
		print("Test must be run on Web export")
		return

	## Simple download in oneline
	# JavaScriptBridge.download_buffer(
	# 	JSON.stringify({"hello": "hi"}).to_utf8_buffer(),
	# 	"savedData.json"
	# )
	#
	# var path = "/tmp/test.cfg"
	# var file = FileAccess.open(path, FileAccess.READ)
	# var error = FileAccess.get_open_error()
	# if error:
	# 	push_error("Failed to load file %s" % error)
	# 	return
	# var fname = path.get_file()
	# # var content = file.get_as_text()
	# var buffer = file.get_buffer(file.get_length())
	# JavaScriptBridge.download_buffer(buffer, fname)

func _on_upload_button():
	if !OS.has_feature('web'):
		print("Test must be run on Web export")
		return

	# window.input.click()
