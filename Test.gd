extends CanvasLayer

var window
var navigator
const ROOM_SIZE = 4

var room_offer: String

# Data channel to connect you to host (you are a guest)
var channel

# Guest data channels to with their ids (you are a host)
var guest_channels: Array[Dictionary]

func not_on_web() -> bool:
	if !OS.has_feature('web'):
		print("Test must be run on Web export")
		return true
	return false

func get_object_from_js(js_args: Array):
	var json = JSON.new()
	var error = json.parse(js_args[0])
	if error != OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", js_args[0], " at line ", json.get_error_line())
		return
	var result = json.data
	return result


# must keep callbacks in global scope so they aren't discarded
var offers_generated_callback = JavaScriptBridge.create_callback(_on_offers_generated)
func _on_offers_generated(args):
	var result = get_object_from_js(args)
	if (!result.success):
		print(result)
		return

	room_offer = result.offerString
	%copy_offer_button.visible = true
	%accept_answer_button.disabled = false
	%generate_offers_button.disabled = true

	%join_room_button.disabled = true

	print(result.message)


var offers_recieved_callback = JavaScriptBridge.create_callback(_on_offers_recieved)
func _on_offers_recieved(args):
	var result = get_object_from_js(args)
	if (!result.success):
		print(result)
		return

	%join_room_button.disabled = true

	%generate_offers_button.disabled = true
	%accept_answer_button.disabled = true

	print(result.message)


var answer_accepted_callback = JavaScriptBridge.create_callback(_on_answer_accepted)
func _on_answer_accepted(args):
	var result = get_object_from_js(args)
	if (!result.success):
		print(result)
		return

	# TODO: check if room is full then disable accpeting answsers

	print(result.message)


var on_channel_open_callback = JavaScriptBridge.create_callback(_on_channel_open)
func _on_channel_open(args):
	var data_channel = args[0]

	# TODO: send message that someone joined
	if args.size() > 1:
		guest_channels.append({"channel": data_channel, "id": args[1]})
	else:
		channel = data_channel

	%lobby_chat_textedit.visible = true
	%send_msg_button.visible = true


func _on_generate_offers_button() -> void:
	if not_on_web():
		return

	# generate connections for each peer, host does not need one
	window.generateRoomConnections(ROOM_SIZE - 1, on_channel_open_callback).then(offers_generated_callback)

func _on_join_room_button() -> void:
	if not_on_web():
		return

	window.receiveConnectionOffers(on_channel_open_callback).then(offers_recieved_callback)

func _on_accept_answer_button() -> void:
	if not_on_web():
		return

	window.acceptAnswer().then(answer_accepted_callback)


func _on_copy_offer_button() -> void:
	if (room_offer):
		navigator.clipboard.writeText(room_offer)
		print("Copied room offer to clipboard")
	else:
		printerr("No room offer in scope")


func _ready():
	%copy_offer_button.visible = false
	%accept_answer_button.disabled = true
	%generate_offers_button.disabled = false

	%join_room_button.disabled = false

	%lobby_chat_textedit.visible = false
	%send_msg_button.visible = false

	if not_on_web():
		return

	# access the window to call js functions
	window = JavaScriptBridge.get_interface("window")
	navigator = JavaScriptBridge.get_interface("navigator")



func _on_send_msg_button_pressed() -> void:
	var text_edit: TextEdit = %lobby_chat_textedit
	var msg = text_edit.text
	text_edit.clear()

	if channel:
		channel.send(msg)
	elif guest_channels:
		for guest in guest_channels: 
			guest.channel.send(msg)
	else:
		printerr("How did you get here?")

	var new_message = ChatMessage.from("Josh", msg)
	%chat_messages.add_child(new_message)
