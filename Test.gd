extends Node2D

var console
var document
var window

func _ready():
	if !OS.has_feature('web'):
		print("Test must be run on Web export")
		return
	
	console = JavaScriptBridge.get_interface("console")
	
	var array = JavaScriptBridge.create_object("Array", 5)
	array[0] = 22
	array[4] = 10
	
	console.table(array)
	
	document = JavaScriptBridge.get_interface("document")
	window = JavaScriptBridge.get_interface("window")
	
	var notificationInt = JavaScriptBridge.get_interface("Notification")
	notificationInt.requestPermission().then(JavaScriptBridge.create_callback(consoleLog))
	# var notif = JavaScriptBridge.create_object("Notification", "Script loaded!")
	# print(notif)
	
	# setup file input
	createFileInput(null)

func consoleLog(args):
	console.log(args)
	print("Callback has fired off")
	print(args)

func createFileInput(_callback: JavaScriptObject):
	
	window.input = document.createElement('input')
	window.input.type = 'file'

	window.input.onchange = window.fileChange
	#window.input.onchange = JavaScriptBridge.create_callback(
		#func(args):
			#print(args)
			#var file = args[0].target.files[0];
			#
			#var reader = JavaScriptBridge.create_object("FilesReader")
			#reader.readAsText(file, 'UTF-8')
			#
			#reader.onload = JavaScriptBridge.create_callback(
				#func(args2):
					#print(args2)
					#callback.call(args2[0].target.result)
			#)
	#)

func createFile():
	var config = ConfigFile.new()
	config.set_value("option", "one", false)
	config.save("/tmp/test.cfg")

func _on_download_button():
	if !OS.has_feature('web'):
		print("Test must be run on Web export")
		return
	
	## Simple download in oneline
	JavaScriptBridge.download_buffer(
		JSON.stringify({"hello": "hi"}).to_utf8_buffer(), 
		"savedData.json"
	)

	var path = "/tmp/test.cfg"
	var file = FileAccess.open(path, FileAccess.READ)
	var error = FileAccess.get_open_error()
	if error:
		push_error("Failed to load file %s" % error)
		return
	var fname = path.get_file()
	# var content = file.get_as_text()
	var buffer = file.get_buffer(file.get_length())
	JavaScriptBridge.download_buffer(buffer, fname)

func _on_upload_button():
	if !OS.has_feature('web'):
		print("Test must be run on Web export")
		return
	
	window.input.click()
