extends Node

var line_edit: LineEdit
var http_request: HTTPRequest
var avatar: Node3D
var anim_node: AnimationPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _ready():
	line_edit = $VBoxContainer/LineEdit
	http_request = $HTTPRequest
	http_request.connect("request_completed", _request_completed)
	
	var scene = load("res://animations/Walk.glb").instantiate()
	anim_node = scene.get_node("AnimationPlayer").duplicate()

func _on_pressed():
	print("button pressed")
	
	if avatar != null:
		avatar.free()
		
	if http_request.request(line_edit.text) != OK:
		push_error("An error occurred in the HTTP request.")

func _request_completed(result, response_code, headers, body):
	if response_code == 200:
		var doc = GLTFDocument.new()
		var state = GLTFState.new()
		if doc.append_from_buffer(body, "base_path?", state, GLTFState.CONNECT_REFERENCE_COUNTED) == OK:
			var avatar = doc.generate_scene(state)
			anim_node.play("Walk")
			avatar.add_child(anim_node)
			add_child(avatar)
			print("loaded")
		else:
			print("error")
