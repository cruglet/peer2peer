class_name Network extends Node

static var port: int = 49132
static var peer: PacketPeerUDP = PacketPeerUDP.new()
const IPV4_RGX: String = r"^(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])){3}$"


static func get_v4_addresses() -> PackedStringArray:
	var regex: RegEx = RegEx.new()
	regex.compile(IPV4_RGX)
	
	var addresses: PackedStringArray = []
	
	var fetched_addresses = IP.get_local_addresses()
	
	for address: String in fetched_addresses:
		if address != "127.0.0.1" and regex.search(address):
			addresses.append(address)
	
	return addresses

static func broadcast_local(data: PackedByteArray, ip: String = "") -> void:
	if peer.get_local_port() == 0 or not peer.is_bound():
		peer = PacketPeerUDP.new()
		peer.bind(Network.port)
	peer.set_broadcast_enabled(true)
	if Debug.FULL_BROADCAST:
		peer.set_dest_address("255.255.255.255", port)
		peer.put_packet(data)
	elif ip:
		peer.set_dest_address(ip, port)
		peer.put_packet(data)
	else:
		peer.set_dest_address(Network.get_broadcast_ip(), port)
		peer.put_packet(data)
			
static func _broaden_ip(ip: String, levels: int) -> String:
	var l: int = levels
	var segments: PackedStringArray = ip.split(".")
	
	for i in range(1, l + 1):
		if i <= segments.size():
			segments[segments.size() - i] = "255"
	
	var broadened_ip: String = segments[0]
	for i in range(1, segments.size()):
		broadened_ip += "." + segments[i]
	
	return broadened_ip


static func get_broadcast_ip() -> String:
	var output: Array
	OS.execute("sh", ["-c", "ifconfig | grep 'inet ' | grep broadcast"], output)
	return output[0].replace("\n", "").split("broadcast ")[1]
