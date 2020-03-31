extends KinematicBody

export var speed = 10
export var acceleration = 5
export var gravity = 0.98
export var jump_power = 30 
export var mouse_sensitivity = 0.3

onready var head = $Head
onready var camera = $Head/Camera

var velocity = Vector3()
var camera_x_rotation = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		
		var x_delta = event.relative.y * mouse_sensitivity
		var new_x_rotation = camera_x_rotation + x_delta
		if new_x_rotation > -90 and new_x_rotation < 90:
			camera.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	var head_basis = head.get_global_transform().basis
	
	var direaction = Vector3() 
	if Input.is_action_pressed("move_forward"):
		direaction -= head_basis.z
	elif Input.is_action_pressed("move_backward"):
		direaction += head_basis.z
	
	if Input.is_action_pressed("move_left"):
		direaction -= head_basis.x
	elif Input.is_action_pressed("move_right"):
		direaction += head_basis.x
	
	direaction = direaction.normalized()
	
	velocity = velocity.linear_interpolate(direaction * speed, acceleration * delta)
	
	velocity.y -= gravity
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump_power
	
	velocity = move_and_slide(velocity, Vector3.UP)
