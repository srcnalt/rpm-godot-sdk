@tool
extends HBoxContainer
class_name SliderWithField

var slider: HSlider
var number: LineEdit

func _ready():
	slider = $HSlider
	number = $LineEdit

func _on_slider_changed(value: float):
	number.text = str(value)
	
func _on_number_changed(text: String):
	var value = float(text)
	slider.value = min(1024, max(0, value))
	number.text = str(slider.value)
