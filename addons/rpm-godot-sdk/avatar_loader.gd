@tool
extends Node

var line_edit: LineEdit
var http_request: HTTPRequest
var scene_instance: Node3D
var guid: String
var anim_node: AnimationPlayer

"""Avatar Config"""
var lod: OptionButton
var pose: OptionButton
var textureAtlas: OptionButton
var textureSizeLimit: HSlider

func _ready():
	line_edit = $VBoxContainer/LineEdit
	http_request = $HTTPRequest
	http_request.connect("request_completed", _request_completed)
	var scene = preload("res://addons/rpm-godot-sdk/walking.glb").instantiate()
	anim_node = scene.get_node("AnimationPlayer").duplicate()
	
	"""Avatar Config"""
	lod = $"VBoxContainer/LOD HBoxContainer/OptionButton"
	pose = $"VBoxContainer/Pose HBoxContainer/OptionButton"
	textureAtlas = $"VBoxContainer/TextureAtlas HBoxContainer/OptionButton"
	textureSizeLimit = $"VBoxContainer/TextureSizeLimit HBoxContainer/HBoxContainer/HSlider"

func _on_pressed():
	if scene_instance != null:
		scene_instance.queue_free()
	
	var url = line_edit.text
	guid = url.split("/")[-1].split("?")[0].replace(".glb", "")
	
	if http_request.request(url + _build_parameters()) != OK:
		push_error("An error occurred in the HTTP request.")

func _request_completed(result, response_code, headers, body):
	if response_code == 200:
		
		var ext = GLTFDocumentExtensionConvertImporterMesh.new()
		var doc = GLTFDocument.new()
		doc.register_gltf_document_extension(ext)
		var state = GLTFState.new()
		state.handle_binary_image = GLTFState.HANDLE_BINARY_EMBED_AS_UNCOMPRESSED
		
		if doc.append_from_buffer(body, "", state) == OK:
			var avatar = doc.generate_scene(state)
			_save_to_scene(avatar)

			var parent = get_tree().edited_scene_root
			var scene: PackedScene = ResourceLoader.load( "res://avatars/" + guid + ".tscn", "", ResourceLoader.CACHE_MODE_REUSE)
			if scene:
				scene.set_name.call_deferred("test")
				scene_instance = scene.instantiate()
				
				scene_instance.set_name(guid)
				parent.add_child(scene_instance)
				scene_instance.set_owner(parent)
			else:
				push_error("Failed to load scene.")

			print("loaded")
		else:
			print("error")

func _save_to_scene(avatar):
	var packed_scene = PackedScene.new()
	packed_scene.resource_name = guid
	avatar.name = guid

	if packed_scene.pack(avatar) == OK:
		if not DirAccess.dir_exists_absolute("res://avatars"):
			DirAccess.make_dir_absolute("res://avatars")
		
		if ResourceSaver.save(packed_scene, "res://avatars/" + guid + ".tscn") == OK:
			print("Scene saved successfully!")
		else:
			push_error("Error while saving scene")
	else:
		push_error("Error while packing scene")

var poses = ["A", "T"]
var textureAtlases = ["none", "256", "512", "1024"]

func _build_parameters() -> String:
	var params = "?"
	params += "lod=" + str(lod.selected) + "&"
	params += "pose=" + poses[pose.selected] + "&"
	params += "textureAtlas=" + textureAtlases[textureAtlas.selected] + "&"
	params += "textureSizeLimit=" + str(textureSizeLimit.value)
	print(params)
	return params
