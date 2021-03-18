extends Node

var vmd_object
var vmd_file_path

func _ready():
	var vmd_parser = Parsers.VmdParser.new()

	vmd_object = vmd_parser.open(vmd_file_path)

	print(vmd_object.get_model_name_in_utf8())
