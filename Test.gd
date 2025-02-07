extends Node2D

var console
var document
var window
var Promise
var navigator
var jsJSON

# must keep callback in global scope so it isn't discarded
var generate_offers_callback = JavaScriptBridge.create_callback(_on_generate_offers)
func _on_generate_offers(args):
	var result = args[0]
	console.log(result)
	print("Offers:", jsJSON.stringify(result))

	navigator.clipboard.writeText(jsJSON.stringify(result))


var parse_offer_callback = JavaScriptBridge.create_callback(_parse_offer_func)
func _parse_offer_func(possible_offer_array):
	if (possible_offer_array):
		print("Possible Offer:", possible_offer_array)
		console.log("Possible Offer:", JSON.stringify(possible_offer_array))
		# var offer_pkg = jsJSON.parse(possible_offer)
		# print(offer_pkg)


var parse_answer_callback = JavaScriptBridge.create_callback(parse_answer_func)
func parse_answer_func(possible_answer):
	if (possible_answer):
		var answer_pkg = jsJSON.parse(possible_answer)
		if (answer_pkg.candidates && answer_pkg.description):
			window.acceptAnswer(answer_pkg)


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


func _on_generate_offers_button():
	if !OS.has_feature('web'):
		print("Test must be run on Web export")
		return

	window.generateRoomConnections() #.then(generate_offers_callback)

func _on_join_room_button():
	if !OS.has_feature('web'):
		print("Test must be run on Web export")
		return

	window.receiveConnectionOffers() #.then(answers_generated_callback)

func _on_accept_answer_button():
	if !OS.has_feature('web'):
		print("Test must be run on Web export")
		return

	window.acceptAnswer()#.then(parse_answer_callback)
	# navigator.clipboard.readText() 
