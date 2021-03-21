class_name Utils

enum BYTES_TYPE { UINT8, UINT32, INT, FLOAT, UTF8, BYTE, CP932, INT8 }

static func get_bytes(file: Object, size: int = 1, type: int = BYTES_TYPE.BYTE):
	var data
	
	if type == BYTES_TYPE.UTF8:
		data = file.get_buffer(size).get_string_from_utf8()
	if type == BYTES_TYPE.CP932:
		data = read_cp932_text(file.get_buffer(size))
	elif type == BYTES_TYPE.BYTE:
		data = file.get_buffer(size)
	elif type == BYTES_TYPE.FLOAT:
		data = file.get_float()
	elif type == BYTES_TYPE.UINT32:
		data = file.get_32()
	elif type == BYTES_TYPE.UINT8:
		data = file.get_8()
	elif type == BYTES_TYPE.INT:
		data = file.get_64()
	elif type == BYTES_TYPE.INT8:
		var number = file.get_8()
		if (number >> 7):
			data = -(number & 127)
		else:
			data = number & 127
	
	return data

static func read_cp932_text(data):
	# reading Shift JIS formatted string
	var substring = PoolByteArray()
	
	for i in data:
		if i == 0:
			break
		substring.append(i)
	
	return substring
