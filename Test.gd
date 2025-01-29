extends Node2D

var console
var document
var window
var Promise
var navigator
var jsJSON

# must keep callback in global scope so it isn't discarded
var generate_offers_callback = JavaScriptBridge.create_callback(_on_generate_offers)
var generate_offers_func = JavaScriptBridge.get_interface("generateRoomConnections")

func _ready():
	if !OS.has_feature('web'):
		print("Test must be run on Web export")
		return

	console = JavaScriptBridge.get_interface("console")
	document = JavaScriptBridge.get_interface("document")
	window = JavaScriptBridge.get_interface("window")
	Promise = JavaScriptBridge.get_interface("Promise")
	navigator = JavaScriptBridge.get_interface("navigator")
	jsJSON = JavaScriptBridge.get_interface("JSON")

	window.generateRoomConnections().then(generate_offers_callback)

func _on_generate_offers(args):
	var result = args[0]
	console.log(result)
	print("Offers:", jsJSON.stringify(result))
	
	navigator.clipboard.writeText(jsJSON.stringify(result))



func _on_download_button():
	if !OS.has_feature('web'):
		print("Test must be run on Web export")
		return

	window.generateRoomConnections().then(generate_offers_callback)

func _on_upload_button():
	if !OS.has_feature('web'):
		print("Test must be run on Web export")
		return

	# window.input.click()
