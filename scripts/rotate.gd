extends Node

var elapsed_time: float = 0.0
var rotation_speed: float = 1.0
var radius: float = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsed_time += delta
	
	var x = radius * cos(elapsed_time * rotation_speed)
	var z = radius * sin(elapsed_time * rotation_speed)
	self.position = Vector3(x, 1, z)
