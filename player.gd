extends CharacterBody3D

@export var move_speed: float = 6.0
@export var jump_velocity: float = 5.5
@export var mouse_sensitivity: float = 0.003
var touch_jump: bool = false
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var pivot: Node3D
var moving_touch := false
var touch_start := Vector2.ZERO
var touch_current := Vector2.ZERO

func _ready() -> void:
    pivot = get_node("CameraPivot")
    if not OS.has_feature("mobile"):
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        rotate_y(-event.relative.x * mouse_sensitivity)
        pivot.rotate_x(-event.relative.y * mouse_sensitivity)
        pivot.rotation.x = clamp(pivot.rotation.x, -0.9, 0.25)
    elif event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    elif event is InputEventScreenTouch:
        if event.pressed and event.position.x < get_viewport().size.x * 0.45:
            moving_touch = true
            touch_start = event.position
            touch_current = event.position
        elif not event.pressed:
            moving_touch = false
    elif event is InputEventScreenDrag:
        if event.position.x < get_viewport().size.x * 0.45 and moving_touch:
            touch_current = event.position
        elif event.position.x >= get_viewport().size.x * 0.45:
            rotate_y(-event.relative.x * mouse_sensitivity * 2.0)
            pivot.rotate_x(-event.relative.y * mouse_sensitivity * 2.0)
            pivot.rotation.x = clamp(pivot.rotation.x, -0.9, 0.25)

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y -= gravity * delta

    var input_vec := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    if Input.is_key_pressed(KEY_A): input_vec.x -= 1.0
    if Input.is_key_pressed(KEY_D): input_vec.x += 1.0
    if Input.is_key_pressed(KEY_W): input_vec.y -= 1.0
    if Input.is_key_pressed(KEY_S): input_vec.y += 1.0

    if moving_touch:
        var d := touch_current - touch_start
        if d.length() > 12.0:
            input_vec = Vector2(clamp(d.x / 70.0, -1.0, 1.0), clamp(d.y / 70.0, -1.0, 1.0))
            input_vec.y = -input_vec.y

    input_vec = input_vec.limit_length(1.0)
    var direction := (transform.basis * Vector3(input_vec.x, 0, input_vec.y)).normalized()
    if direction.length() > 0.01:
        velocity.x = direction.x * move_speed
        velocity.z = direction.z * move_speed
        rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), delta * 8.0)
    else:
        velocity.x = move_toward(velocity.x, 0, move_speed * 5.0 * delta)
        velocity.z = move_toward(velocity.z, 0, move_speed * 5.0 * delta)

    if (Input.is_action_just_pressed("ui_accept") or touch_jump) and is_on_floor():
        velocity.y = jump_velocity
    move_and_slide()
