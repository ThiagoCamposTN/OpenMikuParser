class_name Parsers

class VmdParser:
	static func parse_file(file_path):
		var file = File.new()
		file.open(file_path, File.READ)
		var vmd_object = VmdParser.parse_file_data(file)
		file.close()
		
		return vmd_object
	
	static func parse_file_data(file):
		var vmd_object = Objects.VmdObject.new()
		vmd_object.signature 	= VmdParser.get_signature(file)
		vmd_object.model_name 	= VmdParser.get_model_name(file, vmd_object.signature)
		vmd_object.motions		= VmdParser.get_bone_keyframes(file)
		vmd_object.shapes		= VmdParser.get_face_keyframes(file)
		vmd_object.cameras		= VmdParser.get_camera_keyframes(file)
		vmd_object.lights		= VmdParser.get_light_keyframes(file)
		vmd_object.shadows		= VmdParser.get_shadow_keyframes(file)
		vmd_object.ikdisps		= VmdParser.get_ikdisp_keyframes(file)
		return vmd_object
	
	static func get_signature(file):
		"""
		reads the signature, that contains the current version (30 bytes)
		"""
		return Utils.get_bytes(file, 30, Utils.BYTES_TYPE.UTF8)
		
	static func get_model_name(file, signature):
		"""
		reads the target model name, can have different sizes (10 or 20 bytes)
		"""
		# the next bytes depends of the VMD version (and it's in Shift JIS)
		# if version 1, then model name is 10 bytes long
		# if version 2, then it's 20 bytes
		var data
		
		if signature == "Vocaloid Motion Data file":
			data = Utils.get_bytes(file, 10)
		elif signature == "Vocaloid Motion Data 0002":
			data = Utils.get_bytes(file, 20)
		else:
			assert(false, "ERROR: Invalid VMD version.")
		
		return VmdParser.read_cp932_text(data)
		
	static func read_cp932_text(data):
		# reading Shift JIS formatted string
		var substring = PoolByteArray()
		
		for i in data:
			if i == 0:
				break
			substring.append(i)
			
		return substring
	
	static func get_bone_keyframes(file):
		"""
		reads the bone keyframe list (111 bytes)
		"""
		var keyframes = Utils.get_bytes(file, 1, Utils.BYTES_TYPE.UINT32)
		var frames = []
		
		for _i in range(keyframes):
			var bone_name 		= Utils.get_bytes(file, 15, Utils.BYTES_TYPE.CP932)
			var frame_index 	= Utils.get_bytes(file, 1, Utils.BYTES_TYPE.UINT32)
			var position 		= Vector3(	Utils.get_bytes(file, 1, Utils.BYTES_TYPE.FLOAT), 
											Utils.get_bytes(file, 1, Utils.BYTES_TYPE.FLOAT), 
											Utils.get_bytes(file, 1, Utils.BYTES_TYPE.FLOAT))
			var rotation 		= Quat(	Utils.get_bytes(file, 1, Utils.BYTES_TYPE.FLOAT),
										Utils.get_bytes(file, 1, Utils.BYTES_TYPE.FLOAT),
										Utils.get_bytes(file, 1, Utils.BYTES_TYPE.FLOAT),
										Utils.get_bytes(file, 1, Utils.BYTES_TYPE.FLOAT))
			
			var interpolation 	= Objects.BoneInterpolationData.new(
				Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), 
				Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8),
				Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), 
				Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8),
				Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), 
				Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8),
				Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), 
				Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8),
				Utils.get_bytes(file, 1),
				Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8))
			
			# 45 bytes that are apparently not relevant
			Utils.get_bytes(file, 45)

			frames.append(Objects.BoneFrame.new(bone_name, 
												frame_index,
												position,
												rotation,
												interpolation))
			
		return frames
		
	static func get_face_keyframes(file):
		"""
		reads the face keyframe list (23 bytes)
		"""
		var keyframes 	= Utils.get_bytes(file, 1, Utils.BYTES_TYPE.UINT32)
		var frames 		= []
		
		for _i in range(keyframes):
			var face_name 	= Utils.get_bytes(file, 15, Utils.BYTES_TYPE.CP932)
			var frame_index = Utils.get_bytes(file, 1, Utils.BYTES_TYPE.UINT32)
			var weight 		= Utils.get_bytes(file, 1, Utils.BYTES_TYPE.FLOAT)

			frames.append(Objects.FaceFrame.new(face_name, 
												frame_index,
												weight))
		
		return frames
	
	static func get_camera_keyframes(file):
		"""
		reads the camera keyframe list (61 bytes)
		"""
		var keyframes = Utils.get_bytes(file, 1, Utils.BYTES_TYPE.UINT32)
		var frames = []
		
		for _i in range(keyframes):
			var index 			= Utils.get_bytes(file, 1, Utils.BYTES_TYPE.UINT32)
			var distance 		= Utils.get_bytes(file, 1, Utils.BYTES_TYPE.UINT32)
			var position 		= Vector3(	Utils.get_bytes(file, 1, Utils.BYTES_TYPE.FLOAT), 
											Utils.get_bytes(file, 1, Utils.BYTES_TYPE.FLOAT), 
											Utils.get_bytes(file, 1, Utils.BYTES_TYPE.FLOAT))
			var rotation_euler 	= Vector3(	Utils.get_bytes(file, 1, Utils.BYTES_TYPE.FLOAT), 
											Utils.get_bytes(file, 1, Utils.BYTES_TYPE.FLOAT), 
											Utils.get_bytes(file, 1, Utils.BYTES_TYPE.FLOAT))
			var interpolation 	= Objects.CameraInterpolationData.new(
				Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), 
				Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8),
				Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), 
				Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8),
				Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), 
				Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8),
				Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), 
				Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8),
				Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), 
				Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8),
				Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), 
				Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8), Utils.get_bytes(file, 1, Utils.BYTES_TYPE.INT8))
			var fov_angle 		= Utils.get_bytes(file, 1, Utils.BYTES_TYPE.UINT32)
			var perspective 	= Utils.get_bytes(file, 1, Utils.BYTES_TYPE.UINT8)

			frames.append(Objects.CameraFrame.new(	index, 
													distance,
													position,
													rotation_euler,
													interpolation,
													fov_angle,
													perspective))
			
			break
		
		return frames
	
	static func get_light_keyframes(file):
		"""
		reads the light keyframe list (28 bytes)
		"""
		var keyframes = Utils.get_bytes(file, 1, Utils.BYTES_TYPE.UINT32)
		var frames = []
		
		for _i in range(keyframes):
			var index		= Utils.get_bytes(file, 1, Utils.BYTES_TYPE.UINT32)
			var color		= Color (	Utils.get_bytes(file, 1, Utils.BYTES_TYPE.FLOAT), 
										Utils.get_bytes(file, 1, Utils.BYTES_TYPE.FLOAT), 
										Utils.get_bytes(file, 1, Utils.BYTES_TYPE.FLOAT))
			var position 	= Vector3(	Utils.get_bytes(file, 1, Utils.BYTES_TYPE.FLOAT), 
										Utils.get_bytes(file, 1, Utils.BYTES_TYPE.FLOAT), 
										Utils.get_bytes(file, 1, Utils.BYTES_TYPE.FLOAT))
			
			frames.append(Objects.LightFrame.new(index, color, position))
		
		return frames
	
	static func get_shadow_keyframes(file):
		var keyframes = Utils.get_bytes(file, 1, Utils.BYTES_TYPE.UINT32)
		var frames = []
		
		for _i in range(keyframes):
			var index		= Utils.get_bytes(file, 1, Utils.BYTES_TYPE.UINT32)
			var color		= Utils.get_bytes(file, 1, Utils.BYTES_TYPE.UINT8)
			var position 	= Utils.get_bytes(file, 1, Utils.BYTES_TYPE.FLOAT)
			
			frames.append(Objects.LightFrame.new(index, color, position))
		
		return frames
	
	static func get_ikdisp_keyframes(file):
		var keyframes = Utils.get_bytes(file, 1, Utils.BYTES_TYPE.UINT32)
		var frames = []
		
		for _i in range(keyframes):
			var index						= Utils.get_bytes(file, 1, Utils.BYTES_TYPE.UINT32)
			var inverse_kinematic_display 	= Utils.get_bytes(file, 1, Utils.BYTES_TYPE.UINT8)
			var ik_bones_length				= Utils.get_bytes(file, 1, Utils.BYTES_TYPE.UINT32)
			var ik_bones = []
			
			for _j in range(ik_bones_length):
				var bone_name 				= Utils.get_bytes(file, 20, Utils.BYTES_TYPE.CP932)
				var inverse_kinematic_mode	= Utils.get_bytes(file, 1, Utils.BYTES_TYPE.UINT8)
				ik_bones.append(Objects.InverseKinematicBone.new(bone_name, inverse_kinematic_mode))
			
			frames.append(Objects.InverseKinematicFrame.new(index, inverse_kinematic_display, ik_bones))
		
		return frames
