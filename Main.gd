extends Node

var vmd_file_path

func _ready():
	var vmd_object = Parsers.VmdParser.parse_file(vmd_file_path)

	print(vmd_object.get_model_name_in_utf8())
