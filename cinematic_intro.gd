extends Node3D

const MAIN_SCENE := "res://scenes/main.tscn"
const SCORE_PATH := "res://audio/taqi_cinematic_score.wav"
const INTRO_SECONDS := 10.5

var camera: Camera3D
var title_label: Label
var subtitle_label: Label
var overlay: ColorRect
var elapsed := 0.0
var transitioning := false

func _ready() -> void:
    _build_cinematic_world()
    _build_ui()
    _start_score()
    _animate_title()
    _animate_camera()

func _process(delta: float) -> void:
    if transitioning:
        return
    elapsed += delta
    if elapsed >= INTRO_SECONDS:
        _enter_lobby()

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel") or (event is InputEventScreenTouch and event.pressed and elapsed > 1.0):
        _enter_lobby()

func _build_cinematic_world() -> void:
    var env := WorldEnvironment.new()
    var environment := Environment.new()
    environment.background_mode = Environment.BG_SKY
    var sky := Sky.new()
    var sky_mat := ProceduralSkyMaterial.new()
    sky_mat.sky_top_color = Color(0.025, 0.055, 0.13)
    sky_mat.sky_horizon_color = Color(0.95, 0.35, 0.16)
    sky_mat.ground_bottom_color = Color(0.035, 0.045, 0.07)
    sky_mat.ground_horizon_color = Color(0.32, 0.18, 0.16)
    sky_mat.sun_angle_max = 18.0
    sky.sky_material = sky_mat
    environment.sky = sky
    environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    environment.ambient_light_color = Color(0.48, 0.53, 0.72)
    environment.ambient_light_energy = 0.7
    environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
    env.environment = environment
    add_child(env)

    var sun := DirectionalLight3D.new()
    sun.rotation = Vector3(-0.62, -0.45, 0.0)
    sun.light_color = Color(1.0, 0.58, 0.36)
    sun.light_energy = 1.8
    sun.shadow_enabled = true
    add_child(sun)

    # Layered island terrain silhouettes create depth during the flyover.
    _add_land(Vector3(0, -2.1, -11), Vector3(34, 4.0, 34), Color(0.10,0.20,0.18))
    _add_land(Vector3(-18, -0.1, -29), Vector3(20, 9.0, 16), Color(0.12,0.20,0.23))
    _add_land(Vector3(18, 1.0, -36), Vector3(24, 12.0, 19), Color(0.13,0.19,0.23))
    _add_land(Vector3(0, -1.0, -50), Vector3(44, 15.0, 20), Color(0.17,0.22,0.28))
    _add_land(Vector3(0, -5.0, 0), Vector3(100, 1.0, 100), Color(0.035,0.12,0.16))

    var rng := RandomNumberGenerator.new()
    rng.seed = 20261015
    for i in range(70):
        var x := rng.randf_range(-30,30)
        var z := rng.randf_range(-42,8)
        var scale := rng.randf_range(0.7,1.8)
        _add_tree(Vector3(x, -1.1, z), scale, rng)

    for i in range(5):
        _add_structure(Vector3(-14.0 + i*7.0, -0.7, -20.0-rng.randf_range(0,8)), rng.randf_range(2.5,4.5))

    camera = Camera3D.new()
    camera.current = true
    camera.fov = 58.0
    camera.position = Vector3(0, 20, 22)
    add_child(camera)
    camera.look_at(Vector3(0, -1, -18), Vector3.UP)

func _add_land(pos: Vector3, size: Vector3, color: Color) -> void:
    var node := MeshInstance3D.new()
    var mesh := BoxMesh.new()
    mesh.size = size
    node.mesh = mesh
    node.position = pos
    var mat := StandardMaterial3D.new()
    mat.albedo_color = color
    mat.roughness = 1.0
    node.material_override = mat
    add_child(node)

func _add_tree(pos: Vector3, s: float, rng: RandomNumberGenerator) -> void:
    var root := Node3D.new()
    root.position = pos
    root.scale = Vector3.ONE * s
    add_child(root)
    var trunk := MeshInstance3D.new()
    var trunk_mesh := CylinderMesh.new()
    trunk_mesh.top_radius = 0.12
    trunk_mesh.bottom_radius = 0.22
    trunk_mesh.height = 1.6
    trunk.mesh = trunk_mesh
    trunk.position.y = 0.8
    trunk.material_override = _material(Color(0.19,0.105,0.055))
    root.add_child(trunk)
    for j in range(3):
        var crown := MeshInstance3D.new()
        var cm := ConeMesh.new()
        cm.top_radius = 0.0
        cm.bottom_radius = 1.15 - j*0.2
        cm.height = 1.7
        crown.mesh = cm
        crown.position.y = 1.55 + j*0.68
        crown.material_override = _material(Color(0.035+rng.randf()*0.035,0.13+rng.randf()*0.07,0.075))
        root.add_child(crown)

func _add_structure(pos: Vector3, s: float) -> void:
    var root := Node3D.new()
    root.position = pos
    add_child(root)
    var body := MeshInstance3D.new()
    var mesh := BoxMesh.new()
    mesh.size = Vector3(s*1.6, s, s*1.2)
    body.mesh = mesh
    body.position.y = s*0.5
    body.material_override = _material(Color(0.26,0.28,0.27))
    root.add_child(body)
    var roof := MeshInstance3D.new()
    var rm := BoxMesh.new()
    rm.size = Vector3(s*1.75,0.22,s*1.35)
    roof.mesh = rm
    roof.position.y = s+0.1
    roof.material_override = _material(Color(0.095,0.12,0.13))
    root.add_child(roof)

func _material(color: Color) -> StandardMaterial3D:
    var mat := StandardMaterial3D.new()
    mat.albedo_color = color
    mat.roughness = 0.92
    return mat

func _build_ui() -> void:
    var layer := CanvasLayer.new()
    add_child(layer)
    overlay = ColorRect.new()
    overlay.color = Color(0,0,0,1)
    overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    layer.add_child(overlay)
    var fade := create_tween()
    fade.tween_property(overlay, "color:a", 0.0, 1.8)

    title_label = Label.new()
    title_label.text = "TAQI GAMES"
    title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title_label.anchor_left = 0.08
    title_label.anchor_right = 0.92
    title_label.anchor_top = 0.35
    title_label.anchor_bottom = 0.53
    title_label.add_theme_font_size_override("font_size", 54)
    title_label.add_theme_color_override("font_color", Color(1.0,0.79,0.37))
    title_label.add_theme_color_override("font_shadow_color", Color(0,0,0,0.9))
    title_label.add_theme_constant_override("shadow_offset_x", 3)
    title_label.add_theme_constant_override("shadow_offset_y", 4)
    title_label.modulate.a = 0.0
    layer.add_child(title_label)

    subtitle_label = Label.new()
    subtitle_label.text = "PLAY  •  FIGHT  •  SURVIVE"
    subtitle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    subtitle_label.anchor_left = 0.08
    subtitle_label.anchor_right = 0.92
    subtitle_label.anchor_top = 0.53
    subtitle_label.anchor_bottom = 0.61
    subtitle_label.add_theme_font_size_override("font_size", 19)
    subtitle_label.add_theme_color_override("font_color", Color(0.88,0.92,0.98))
    subtitle_label.modulate.a = 0.0
    layer.add_child(subtitle_label)

    var skip := Button.new()
    skip.text = "SKIP  ›"
    skip.anchor_left = 1.0
    skip.anchor_right = 1.0
    skip.anchor_top = 1.0
    skip.anchor_bottom = 1.0
    skip.offset_left = -132
    skip.offset_right = -22
    skip.offset_top = -70
    skip.offset_bottom = -24
    skip.add_theme_font_size_override("font_size", 18)
    layer.add_child(skip)
    skip.pressed.connect(_enter_lobby)

func _animate_title() -> void:
    var tw := create_tween()
    tw.tween_interval(0.65)
    tw.tween_property(title_label, "modulate:a", 1.0, 1.2)
    tw.parallel().tween_property(title_label, "scale", Vector2.ONE, 1.2)
    tw.tween_interval(0.35)
    tw.tween_property(subtitle_label, "modulate:a", 1.0, 1.0)

func _animate_camera() -> void:
    var start := camera.position
    var end := Vector3(10, 9, -3)
    var tw := create_tween()
    tw.set_trans(Tween.TRANS_SINE)
    tw.set_ease(Tween.EASE_IN_OUT)
    tw.tween_property(camera, "position", end, INTRO_SECONDS)
    tw.parallel().tween_method(func(v: Vector3): camera.look_at(v, Vector3.UP), Vector3(0,-1,-18), Vector3(0,0,-23), INTRO_SECONDS)

func _start_score() -> void:
    if ResourceLoader.exists(SCORE_PATH):
        var player := AudioStreamPlayer.new()
        player.stream = load(SCORE_PATH)
        player.volume_db = -7.0
        player.autoplay = true
        add_child(player)
        player.play()

func _enter_lobby() -> void:
    if transitioning:
        return
    transitioning = true
    var tw := create_tween()
    tw.tween_property(overlay, "color:a", 1.0, 0.65)
    tw.tween_callback(func(): get_tree().change_scene_to_file(MAIN_SCENE))
