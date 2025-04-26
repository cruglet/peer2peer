class_name User extends Resource

@export var user_id: String
@export var username: String
@export var profile_picture: CompressedTexture2D
@export var friends_list: Array[User] = []
