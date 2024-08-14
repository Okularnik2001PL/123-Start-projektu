extends CharacterBody3D
var camera=1
var prędkośc_obrotu=0.1
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*prędkośc_obrotu))
		get_node("Camera3D2").rotate_x(deg_to_rad(-event.relative.y*prędkośc_obrotu))

func _physics_process(delta):
	#print(str($Camera3D2/RayCast3D.get_collider()))
	if Input.is_action_just_pressed("zmiana_kamery"):
		camera=-camera
		match camera:
			-1:
				$Camera3D2/Camera3D.current=true
				$Camera3D2.current=false
			1:
				$Camera3D2/Camera3D.current=false
				$Camera3D2.current=true
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
