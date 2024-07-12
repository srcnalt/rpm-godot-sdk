@tool
extends HBoxContainer
class_name MultiSelect

var item_list: ItemList
var items: Array = []

func _ready() -> void:
	item_list = $"ItemList"
	items.append("none")

func _on_item_list_multi_selected(index: int, selected: bool) -> void:
	pass # Replace with function body.
