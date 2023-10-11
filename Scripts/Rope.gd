extends Node2D

const rope_seg = preload("res://Prefabs/Rope/rope_seg.tscn")

@export var rope_close_tolerance : float

var rope_parts := []
var hook
var player

func _ready():
	hook = $Hook

func spawn_rope(player_ref, num_points, dirVector):
	var segment_amount = num_points # divided by length of rope segment
	var spawn_angle = dirVector.angle() - PI/2
	var hook_pos = hook.get_node("C/J").global_position
	player = player_ref
	
	create_rope(segment_amount, player, hook_pos,spawn_angle)
	

func create_rope(num_pieces: int, parent:Object, hook_pos:Vector2, spawn_angle:float):
	rope_parts = []
	for i in num_pieces:
		parent = add_piece(parent, i, spawn_angle)
		rope_parts.append(parent)
		
		var joint_pos = parent.get_node("C/J").global_position
#		if joint_pos.distance_to(hook_pos) < rope_close_tolerance:
#			break
	
	hook.get_node("C/J").node_a = hook.get_path()
	hook.get_node("C/J").node_b = rope_parts[-1].get_path()
	

func add_piece(parent: Object, id: int, spawn_angle:float):
	var joint : PinJoint2D = parent.get_node("C/J") as PinJoint2D
	var piece : Object = rope_seg.instantiate() as Object
	
	piece.global_position = Vector2.ZERO
	piece.rotation = spawn_angle
	piece.parent = self
	piece.id = id
	add_child(piece)
	piece.set_name("rope_piece_"+str(id))
	joint.node_a = parent.get_path()
	joint.node_b = piece.get_path()
	
	return piece
