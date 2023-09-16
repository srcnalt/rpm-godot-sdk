@tool
extends Node

var line_edit: LineEdit
var http_request: HTTPRequest
var avatar: Node3D
var anim_node: AnimationPlayer

func _ready():
	line_edit = $VBoxContainer/LineEdit
	http_request = $HTTPRequest
	http_request.connect("request_completed", _request_completed)
	var scene = preload("res://addons/rpm-godot-sdk/walking.glb").instantiate()
	anim_node = scene.get_node("AnimationPlayer").duplicate()
	print("loaded")

func _on_pressed():
	print("button pressed")
	
	if avatar != null:
		avatar.free()
		
	if http_request.request(line_edit.text) != OK:
		push_error("An error occurred in the HTTP request.")

func _request_completed(result, response_code, headers, body):
	if response_code == 200:
		_save_glb_to_avatars_folder(body)
		
		var parent = get_tree().edited_scene_root
		GLTFExtensions
		var doc = GLTFDocument.new()
		var state = GLTFState.new()
		if doc.append_from_buffer(body, "", state) == OK:
			avatar = doc.generate_scene(state)
			var instance = avatar.instantiate()
			parent.add_child(instance)
			instance.set_owner(parent)
			print("loaded")
		else:
			print("error")

func _save_glb_to_avatars_folder(body):
	# Ensure the "avatars" directory exists
	if not DirAccess.dir_exists_absolute("res://avatars"):
		DirAccess.make_dir_absolute("res://avatars")

	# Save the file
	var file_name = "res://avatars/avatar.glb"
	var file = FileAccess.open(file_name, FileAccess.WRITE)
	
	if file.get_open_error() == OK:
		file.store_buffer(body)
		file.close()
	else:
		push_error("Failed to save the GLB file.")
		
	
