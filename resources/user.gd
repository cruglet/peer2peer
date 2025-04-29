class_name User extends Resource

@export var user_id: int
@export var about: String
@export var username: String
@export var profile_picture_data: PackedByteArray
@export var friends_list: Array[User] = []
@export var modulate_pfp: Color = Color.WHITE
