extends CharacterBody3D
var camera=1
var prędkośc_obrotu=0.1
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var ładunek=3
var tszymam=null
var Skszynka=preload("res://Klocekv1.tscn")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func _ready():
	odswierz()
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*prędkośc_obrotu))
		get_node("Camera3D2").rotate_x(deg_to_rad(-event.relative.y*prędkośc_obrotu))

func _physics_process(delta):
	print(str($Camera3D2/RayCast3D.get_collider()))
	if Input.is_action_just_pressed("zmiana_kamery"):
		camera=-camera
		match camera:
			-1:
				$Camera3D2/Camera3D.current=true
				$Camera3D2.current=false
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			1:
				$Camera3D2/Camera3D.current=false
				$Camera3D2.current=true
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("spawn")&&tszymam==null:
		if ładunek>=1:
			var szkszynia=Skszynka.instantiate()
			add_child(szkszynia)
			podniesiony(szkszynia)
			ładunek-=1
			odswierz()
	if Input.is_action_just_pressed("Prawy_M"):
		if $Camera3D2/RayCast3D.get_collider()!=null:
			if $Camera3D2/RayCast3D.get_collider().is_in_group("podnieś"):
				if tszymam==null:
					podniesiony($Camera3D2/RayCast3D.get_collider())
			if  $Camera3D2/RayCast3D.get_collider().is_in_group("zbieraj"):
				ładunek+=10
				odswierz()
			else :
				odluz()
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
func podniesiony(obiekt):
	obiekt.set_collision_layer_value(1,false)
	obiekt.set_collision_mask_value(1,false)
	obiekt.gravity_scale = 0 
	obiekt.get_parent().remove_child(obiekt)
	add_child(obiekt)
	obiekt.global_position=$nosze.global_position
	tszymam=obiekt
func odluz():
	if tszymam!=null:
		tszymam.set_collision_layer_value(1,true)
		tszymam.set_collision_mask_value(1,true)
		tszymam.gravity_scale = 1
		tszymam.get_parent().remove_child(tszymam)
		get_parent().add_child(tszymam)
		tszymam.global_position=punkt()
		tszymam=null
func punkt():
	var punkt=$nosze
	if $Camera3D2/RayCast3D.is_colliding():
		punkt= $Camera3D2/RayCast3D.get_collision_point()
	else:
		punkt= $Camera3D2/RayCast3D.global_transform.origin 
	return punkt
func odswierz():
	$Camera3D2/Inter1/Label.text=str(ładunek)
