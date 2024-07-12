extends Node

var current_avatar: Node3D
var line_edit: LineEdit
var http_request: HTTPRequest
var anim_node: AnimationPlayer
var runtime_loader: RuntimeAvatarLoader
var avatar_config: AvatarConfig

func _ready():
	line_edit = $RuntimeAvatarLoader/VBoxContainer/LineEdit
	runtime_loader = $RuntimeAvatarLoader
	
	var scene = load("res://animations/Walk.glb").instantiate()
	anim_node = scene.get_node("AnimationPlayer").duplicate()
	
	avatar_config = AvatarConfig.new()
	avatar_config.lod = AvatarConfig.Lod.MEDIUM
	avatar_config.texture_atlas = AvatarConfig.TextureAtlas.SIZE_512
	avatar_config.pose = AvatarConfig.Pose.A_POSE
	avatar_config.texture_size_limit = 512
	
func _on_button_pressed():
	runtime_loader.load_avatar(line_edit.text)
	runtime_loader.on_completed.connect(_on_avatar_loaded)
	
func _on_avatar_loaded(avatar):
	print("here")
	if current_avatar != null:
		current_avatar.free()
	
	current_avatar = avatar
	
	anim_node.play("Walk")
	current_avatar.add_child(anim_node)
	
	add_child(avatar)
