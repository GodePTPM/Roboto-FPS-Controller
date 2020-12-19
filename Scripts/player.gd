extends Node

var cameraSpatial
var kinematicBody

var mouseSensibility = 0.25

var charSpeed = 5.0
var currentSpeed = 0.0

var accelerateInterpolation = 0.0
var decelerateInterpolation = 0.0

var prevVector = Vector3(0,0,0)

func _ready():
	cameraSpatial = get_node("camera_spatial")
	kinematicBody = get_node("KinematicBody")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	accelerateInterpolation = clamp(accelerateInterpolation+delta, 0, 1)
	decelerateInterpolation = clamp(decelerateInterpolation+delta, 0, 1)
	var moveVector = Vector3(0,-5,0)
	
	var moving = false
	
	if Input.is_action_pressed("walk_left"):
		moveVector += -kinematicBody.get_global_transform().basis.x*currentSpeed; moving = true
	if Input.is_action_pressed("walk_right"):
		moveVector += kinematicBody.get_global_transform().basis.x*currentSpeed; moving = true
	if Input.is_action_pressed("walk_forward"):
		moveVector += -kinematicBody.get_global_transform().basis.z*currentSpeed; moving = true
	if Input.is_action_pressed("walk_backward"):
		moveVector += kinematicBody.get_global_transform().basis.z*currentSpeed; moving = true
	
	kinematicBody.set_rotation(Vector3(0, cameraSpatial.get_rotation().y, 0))
	
	if !moving:
		accelerateInterpolation = 0
		currentSpeed = lerp(currentSpeed, 0, decelerateInterpolation)
		kinematicBody.move_and_slide(moveVector+(prevVector*currentSpeed), Vector3.UP)
	else:
		decelerateInterpolation = 0
		currentSpeed = lerp(currentSpeed, charSpeed, accelerateInterpolation)
		kinematicBody.move_and_slide(moveVector, Vector3.UP)
		prevVector = (moveVector-Vector3(0,-5,0))/currentSpeed
	
	cameraSpatial.translation = kinematicBody.translation


func _input(event):
	if event is InputEventMouseMotion:
		cameraSpatial.rotation_degrees.x += -event.relative.y*mouseSensibility
		cameraSpatial.rotation_degrees.x = clamp(cameraSpatial.rotation_degrees.x, -80, 60)
		cameraSpatial.rotation_degrees.y += -event.relative.x*mouseSensibility
