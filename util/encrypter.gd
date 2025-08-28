class_name Encrypt

static var KEY: PackedByteArray = "sixseven".to_utf8_buffer()

static func string(msg: String) -> PackedByteArray:
	var data: PackedByteArray = msg.to_utf8_buffer()
	var result: PackedByteArray = []
	for i in data.size():
		result.append(data[i] ^ KEY[i % KEY.size()])
	return result

static func decode_string(data: PackedByteArray) -> String:
	var result: PackedByteArray = []
	for i in data.size():
		result.append(data[i] ^ KEY[i % KEY.size()])
	return result.get_string_from_utf8()
