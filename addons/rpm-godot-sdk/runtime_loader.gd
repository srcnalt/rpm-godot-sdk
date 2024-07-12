extends HTTPRequest
class_name RuntimeAvatarLoader

signal on_completed

var thread : Thread
var avatar_url : String

# this will need avatarConfig script too
func load_avatar(url):
	connect("request_completed", _on_http_request_completed)
	if request(url) != OK:
		push_error("An error occurred in the HTTP request.")

func _on_http_request_completed(result, response_code, headers, body):
	if response_code == 200:
		# Start a new thread to process the GLB file
		WorkerThreadPool.add_task(_process_glb_in_thread.bind(body), true)
	else:
		print("HTTP request error with response code: %d" % response_code)

func _process_glb_in_thread(body):
	var doc = GLTFDocument.new()
	var state = GLTFState.new()
	if doc.append_from_buffer(body, "base_path?", state, GLTFState.CONNECT_REFERENCE_COUNTED) == OK:
		# Move the result to the main thread
		call_deferred("_on_avatar_loaded", doc, state)
	else:
		print("GLB loading error")
		call_deferred("_on_avatar_loaded", null)
	
	return

func _on_avatar_loaded(doc, state):
	var avatar = doc.generate_scene(state)
	
	on_completed.emit(avatar)
