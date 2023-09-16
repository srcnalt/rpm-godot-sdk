@tool
extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_button_pressed():
	var parent = get_tree().edited_scene_root
	var node = Node3D.new()
	parent.add_child(node)
	node.set_owner(parent)
