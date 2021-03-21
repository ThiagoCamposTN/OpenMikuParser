class_name Objects

class VmdObject:
	var signature
	var model_name
	var motions
	var shapes
	var cameras
	var lights
	var shadows
	var ikdisps
	
	func _init():
		pass
	
	func get_model_name_in_utf8():
		return Encoders.sjis_to_utf8(self.model_name)

class BoneFrame:
	var name
	var index
	var position
	var rotation
	var interpolation
	
	func _init( bone_name, frame_index, bone_position, 
				bone_rotation, bone_interpolation):
		self.name 			= bone_name
		self.index 			= frame_index
		self.position 		= bone_position
		self.rotation 		= bone_rotation
		self.interpolation 	= bone_interpolation
	
	func get_name_in_utf8():
		return Encoders.sjis_to_utf8(self.name)
	
class FaceFrame:
	var name
	var index
	var weight
	
	func _init(face_name, frame_index, face_weight):
		self.name	= face_name
		self.index	= frame_index
		self.weight	= face_weight
	
	func get_name_in_utf8():
		return Encoders.sjis_to_utf8(self.name)

class CameraFrame:
	var index
	var camera_target_distance
	var target_position
	var rotation_euler
	var interpolation
	var fov_angle
	var perspective
	
	func _init( frame_index, distance, position, 
				camera_rotation, camera_interpolation, 
				camera_fov_angle, camera_perspective):
		self.index                  = frame_index
		self.camera_target_distance = distance
		self.target_position        = position
		self.rotation_euler         = camera_rotation
		self.interpolation          = camera_interpolation
		self.fov_angle              = camera_fov_angle
		self.perspective            = camera_perspective

class InterpolationPoint:
	var a
	var b
	
	func _init(a, b):
		self.a = a
		self.b = b

class CameraInterpolationData:
	var x_axis_move
	var y_axis_move
	var z_axis_move
	var rotation
	var distance
	var view_angle
	
	func _init( x_ax, x_bx, x_ay, x_by, 
				y_ax, y_bx, y_ay, y_by, 
				z_ax, z_bx, z_ay, z_by, 
				r_ax, r_bx, r_ay, r_by,
				dist_ax, dist_bx, dist_ay, dist_by, 
				ang_ax, ang_bx, ang_ay, ang_by):
		self.x_axis_move	= InterpolationPoint.new(	Vector2(x_ax, x_ay),
														Vector2(x_bx, x_by))
		self.y_axis_move	= InterpolationPoint.new(	Vector2(y_ax, y_ay),
														Vector2(y_bx, y_by))
		self.z_axis_move	= InterpolationPoint.new(	Vector2(z_ax, z_ay),
														Vector2(z_bx, z_by))
		self.rotation		= InterpolationPoint.new(	Vector2(r_ax, r_ay),
														Vector2(r_bx, r_by))
		self.distance		= InterpolationPoint.new(	Vector2(dist_ax, dist_ay),
														Vector2(dist_bx, dist_by))
		self.view_angle		= InterpolationPoint.new(	Vector2(ang_ax, ang_ay),
														Vector2(ang_bx, ang_by))

class LightFrame:
	var index
	var color
	var position
	
	func _init(frame_index, light_color, light_position):
		self.index 		= frame_index
		self.color 		= light_color
		self.position 	= light_position

class ShadowFrame:
	var index
	var mode
	var range_value
	
	func _init(frame_index, shadow_mode, shadow_range_value):
		self.index			= frame_index
		self.mode 			= shadow_mode
		self.range_value 	= shadow_range_value

class InverseKinematicBone:
	var bone_name
	var ik_enabled
	
	func _init(bone_name, inverse_kinematic_mode):
		self.bone_name	= bone_name
		self.ik_enabled = inverse_kinematic_mode
	
	func get_bone_name_in_utf8():
		return Encoders.sjis_to_utf8(self.bone_name)

class InverseKinematicFrame:
	var index
	var display
	var bones

	func _init(frame_index, inverse_kinematic_display, ik_bones):
		self.index		= frame_index
		self.display 	= inverse_kinematic_display
		self.bones		= ik_bones
		
class BoneInterpolationData:
	var x_axis_move
	var y_axis_move
	var z_axis_move
	var rotation
	var physics_off
	
	func _init( x_ax, y_ax,
				phys1, phys2,
				x_ay, y_ay, z_ay, r_ay,
				x_bx, y_bx, z_bx, r_bx,
				x_by, y_by, z_by, r_by,
				padding_byte,
				z_ax, r_ax):
		self.x_axis_move	= InterpolationPoint.new(	Vector2(x_ax, x_ay),
														Vector2(x_bx, x_by))
		self.y_axis_move	= InterpolationPoint.new(	Vector2(y_ax, y_ay),
														Vector2(y_bx, y_by))
		self.z_axis_move	= InterpolationPoint.new(	Vector2(z_ax, z_ay),
														Vector2(z_bx, z_by))
		self.rotation		= InterpolationPoint.new(	Vector2(r_ax, r_ay),
														Vector2(r_bx, r_by))
		
		if phys1 == z_ax and phys2 == r_ax or phys1 == phys2 == 0:
			# physics is on
			self.physics_off = false
		elif phys1 == 99 and phys2 == 15:
			# physics is off
			self.physics_off = true
		else:
			# assuming physics is off
			self.physics_off = true
