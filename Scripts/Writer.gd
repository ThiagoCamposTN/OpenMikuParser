class_name Writer

static func export_vmd_to_omd(vmd_object : Objects.VmdObject):
	var file = File.new()
	file.open("a.txt", File.WRITE_READ)
	
#	file.store_var(vmd_object.model_name.hex_encode())
	
#	var data = [118, 101, 114, 115, 105, 111, 110, 58, 44, 50, 
#				10, 109, 111, 100, 101, 108, 110, 97, 109, 101, 
#				58, 44, 231, 153, 189, 232, 152, 173, 227, 131, 
#				159, 227, 131, 171, 227, 131, 149, 227, 130, 163, 
#				227, 130, 170, 227, 131, 188, 227, 131, 172, 10, 
#				98, 111, 110, 101, 102, 114, 97, 109, 101, 95, 99, 
#				116, 58, 44, 51, 56, 52, 50, 48, 10]
#
#	var text = PoolByteArray(data)
#
#	file.store_var(text)
#	file.store_string(".白.蘭.ミ.ル.フ.ィ.オ.ー.レ.")

	print(vmd_object.model_name.hex_encode())
	
	"""
	白蘭ミルフィオーレ
	(UTF-8) 	E7 99 BD E8 98 AD E3 83 9F E3 83 AB E3 83 95 E3 82 A3 E3 82 AA E3 83 BC E3 83 AC
	(SHIFT JIS) 94 92 97 96 83 7e 83 8b 83 74 83 42 83 49 81 5b 83 8c
	"""
	
	file.close()
