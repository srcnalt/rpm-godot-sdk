extends Resource
class_name AvatarConfig

enum Lod { LOW, MEDIUM, HIGH }
enum TextureAtlas { NONE, SIZE_256, SIZE_512, SIZE_1024 }

@export var lod: Lod = Lod.LOW
@export var textureAtlas: TextureAtlas = TextureAtlas.NONE
