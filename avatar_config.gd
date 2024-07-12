extends Resource
class_name AvatarConfig

enum Pose { A_POSE, T_POSE }
enum Lod { LOW, MEDIUM, HIGH }
enum TextureAtlas { NONE, SIZE_256, SIZE_512, SIZE_1024 }
enum TextureChannels { BASE_COLOR, NORMAL, METALLIC_ROUGHNESS, EMISSIVE, OCCLUSION, NONE }

@export var pose: Pose = Pose.A_POSE
@export var lod: Lod = Lod.LOW
@export var texture_atlas: TextureAtlas = TextureAtlas.NONE
@export var texture_size_limit: int = 1024
@export var texture_channels: Array = [TextureChannels.BASE_COLOR, TextureChannels.NORMAL]

func get_texture_channels_string() -> String:
	if len(texture_channels) == 0:
		return "none"
	
	var value = ""
	for channel in texture_channels:
		match channel:
			TextureChannels.BASE_COLOR:
				value += "baseColor,"
			TextureChannels.NORMAL:
				value += "normal,"
			TextureChannels.METALLIC_ROUGHNESS:
				value += "metallicRoughness,"
			TextureChannels.EMISSIVE:
				value += "emissive,"
			TextureChannels.OCCLUSION:
				value += "occlusion,"
			TextureChannels.NONE:
				value += "none,"
	
	return value
	
func get_pose_string() -> String:
	return "A" if pose == Pose.A_POSE else "T"
	
func get_texture_atlas_string() -> String:
	match texture_atlas:
		TextureAtlas.SIZE_256:
			return "256"
		TextureAtlas.SIZE_512:
			return "512"
		TextureAtlas.SIZE_1024:
			return "1024"
	
	return "none"

func build_parameters() -> String:
	var params = "?"
	params += "lod=" + str(lod) + "&"
	params += "pose=" + get_pose_string() + "&"
	params += "textureAtlas=" + get_texture_atlas_string() + "&"
	params += "textureSizeLimit=" + str(texture_size_limit) + "&"
	params += "textureChannels=" + get_texture_channels_string()
	
	print(params)
	return params
