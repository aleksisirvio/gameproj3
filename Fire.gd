extends Sprite2D

var dir : float = 1
var spd : float = 0
var acc : float = .001
const max_spd : float = .005
const max_deviation : float = .01

var orig_scale : float = .2

var rot_dir : float = 1
var rot_spd : float = 0
var rot_acc : float = .2
const max_rot_spd : float = 1
const max_rot : float = 5


func _ready():
	orig_scale = scale.y


func _process(delta):
	# Rescale for illusion of movement
	if abs(spd) < max_spd or sign(spd) != dir:
		spd += dir * acc * delta * 60
	scale.y += spd * delta * 60
	if scale.y >= orig_scale + max_deviation:
		dir = -1
	if scale.y <= orig_scale - max_deviation:
		dir = 1

	# Rotate for illusion of movement
	if abs(rot_spd) < max_rot_spd or sign(rot_spd) != rot_dir:
		rot_spd += rot_dir * rot_acc * delta * 60
	rotation_degrees += rot_spd * delta * 60
	if rotation_degrees >= max_rot:
		rot_dir = -1
	if rotation_degrees <= -max_rot:
		rot_dir = 1
