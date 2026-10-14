extends Node3D

const LOBBY_SCENE := "res://scenes/lobby.tscn"
const SCORE_PATH := "res://audio/taqi_cinematic_score.wav"
const INTRO_SECONDS := 10.0
var camera: Camera3D
var title_label: Label
var subtitle_label: Label
var overlay: ColorRect
var elapsed := 0.0
var transitioning := false
var look_target := Vector3(0,-1,-18)

func _ready() -> void:
    _build_world()
    _build_ui()
    _play_score()
    _animate_title()

func _process(delta: float) -> void:
    if transitioning:
        return
    elapsed += delta
    camera.position = Vector3(lerp(0.0, 10.0, elapsed/INTRO_SECONDS), lerp(20.0, 9.0, elapsed/INTRO_SECONDS), lerp(22.0, -3.0, elapsed/INTRO_SECONDS))
    look_target = Vector3(0, lerp(-1.0,0.0,elapsed/INTRO_SECONDS), lerp(-18.0,-23.0,elapsed/INTRO_SECONDS))
    camera.look_at(look_target, Vector3.UP)
    if elapsed >= INTRO_SECONDS:
        _enter_lobby()

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        _enter_lobby()
    elif event is InputEventScreenTouch and event.pressed and elapsed > 1.0:
        _enter_lobby()

func _build_world() -> void:
    var env_node := WorldEnvironment.new()
    var env := Environment.new()
    env.background_mode = Environment.BG_SKY
    var sky := Sky.new()
    var sky_mat := ProceduralSkyMaterial.new()
    sky_mat.sky_top_color=Color(0.025,0.055,0.13)
    sky_mat.sky_horizon_color=Color(0.95,0.35,0.16)
    sky_mat.ground_bottom_color=Color(0.035,0.045,0.07)
    sky_mat.ground_horizon_color=Color(0.32,0.18,0.16)
    sky.sky_material=sky_mat
    env.sky=sky
    env.ambient_light_source=Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color=Color(0.48,0.53,0.72)
    env.ambient_light_energy=0.7
    env.tonemap_mode=Environment.TONE_MAPPER_FILMIC
    env_node.environment=env
    add_child(env_node)

    var sun := DirectionalLight3D.new()
    sun.rotation=Vector3(-0.62,-0.45,0)
    sun.light_color=Color(1.0,0.58,0.36)
    sun.light_energy=1.6
    sun.shadow_enabled=true
    add_child(sun)

    _land(Vector3(0,-2.1,-11),Vector3(34,4,34),Color(0.10,0.20,0.18))
    _land(Vector3(-18,-0.1,-29),Vector3(20,9,16),Color(0.12,0.20,0.23))
    _land(Vector3(18,1,-36),Vector3(24,12,19),Color(0.13,0.19,0.23))
    _land(Vector3(0,-1,-50),Vector3(44,15,20),Color(0.17,0.22,0.28))
    _land(Vector3(0,-5,0),Vector3(100,1,100),Color(0.035,0.12,0.16))

    var rng := RandomNumberGenerator.new()
    rng.seed=20261015
    for i in range(45):
        _tree(Vector3(rng.randf_range(-30,30),-1.1,rng.randf_range(-42,8)),rng.randf_range(0.7,1.6),rng)
    for i in range(5):
        _building(Vector3(-14.0+i*7.0,-0.7,-20.0-rng.randf_range(0,8)),rng.randf_range(2.5,4.5))

    camera=Camera3D.new()
    camera.current=true
    camera.fov=58.0
    camera.position=Vector3(0,20,22)
    add_child(camera)
    camera.look_at(look_target,Vector3.UP)

func _land(pos: Vector3,size: Vector3,color: Color) -> void:
    var n:=MeshInstance3D.new()
    var m:=BoxMesh.new()
    m.size=size
    n.mesh=m
    n.position=pos
    n.material_override=_mat(color)
    add_child(n)

func _tree(pos: Vector3,s: float,rng: RandomNumberGenerator) -> void:
    var root:=Node3D.new()
    root.position=pos
    root.scale=Vector3.ONE*s
    add_child(root)
    var trunk:=MeshInstance3D.new()
    var tm:=CylinderMesh.new()
    tm.top_radius=0.12
    tm.bottom_radius=0.22
    tm.height=1.6
    trunk.mesh=tm
    trunk.position.y=0.8
    trunk.material_override=_mat(Color(0.19,0.105,0.055))
    root.add_child(trunk)
    for j in range(3):
        var crown:=MeshInstance3D.new()
        var cm:=ConeMesh.new()
        cm.bottom_radius=1.15-j*0.2
        cm.height=1.7
        crown.mesh=cm
        crown.position.y=1.55+j*0.68
        crown.material_override=_mat(Color(0.035+rng.randf()*0.035,0.13+rng.randf()*0.07,0.075))
        root.add_child(crown)

func _building(pos: Vector3,s: float) -> void:
    var root:=Node3D.new()
    root.position=pos
    add_child(root)
    var body:=MeshInstance3D.new()
    var bm:=BoxMesh.new()
    bm.size=Vector3(s*1.6,s,s*1.2)
    body.mesh=bm
    body.position.y=s*0.5
    body.material_override=_mat(Color(0.26,0.28,0.27))
    root.add_child(body)
    var roof:=MeshInstance3D.new()
    var rm:=BoxMesh.new()
    rm.size=Vector3(s*1.75,0.22,s*1.35)
    roof.mesh=rm
    roof.position.y=s+0.1
    roof.material_override=_mat(Color(0.095,0.12,0.13))
    root.add_child(roof)

func _mat(color: Color) -> StandardMaterial3D:
    var m:=StandardMaterial3D.new()
    m.albedo_color=color
    m.roughness=0.92
    return m

func _build_ui() -> void:
    var layer:=CanvasLayer.new()
    add_child(layer)
    overlay=ColorRect.new()
    overlay.color=Color(0,0,0,1)
    overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    layer.add_child(overlay)
    var fade:=create_tween()
    fade.tween_property(overlay,"color:a",0.0,1.5)

    title_label=Label.new()
    title_label.text="TAQI GAMES"
    title_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
    title_label.vertical_alignment=VERTICAL_ALIGNMENT_CENTER
    title_label.anchor_left=0.08
    title_label.anchor_right=0.92
    title_label.anchor_top=0.35
    title_label.anchor_bottom=0.53
    title_label.add_theme_font_size_override("font_size",54)
    title_label.add_theme_color_override("font_color",Color(1.0,0.79,0.37))
    title_label.modulate.a=0
    layer.add_child(title_label)

    subtitle_label=Label.new()
    subtitle_label.text="PLAY  •  FIGHT  •  SURVIVE"
    subtitle_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
    subtitle_label.anchor_left=0.08
    subtitle_label.anchor_right=0.92
    subtitle_label.anchor_top=0.53
    subtitle_label.anchor_bottom=0.61
    subtitle_label.add_theme_font_size_override("font_size",19)
    subtitle_label.add_theme_color_override("font_color",Color(0.88,0.92,0.98))
    subtitle_label.modulate.a=0
    layer.add_child(subtitle_label)

    var skip:=Button.new()
    skip.text="SKIP  ›"
    skip.anchor_left=1
    skip.anchor_right=1
    skip.anchor_top=1
    skip.anchor_bottom=1
    skip.offset_left=-132
    skip.offset_right=-22
    skip.offset_top=-70
    skip.offset_bottom=-24
    layer.add_child(skip)
    skip.pressed.connect(_enter_lobby)

func _animate_title() -> void:
    var tw:=create_tween()
    tw.tween_interval(0.7)
    tw.tween_property(title_label,"modulate:a",1.0,1.1)
    tw.tween_interval(0.2)
    tw.tween_property(subtitle_label,"modulate:a",1.0,0.8)

func _play_score() -> void:
    if ResourceLoader.exists(SCORE_PATH):
        var audio:=AudioStreamPlayer.new()
        audio.stream=load(SCORE_PATH)
        audio.volume_db=-8.0
        add_child(audio)
        audio.play()

func _enter_lobby() -> void:
    if transitioning:
        return
    transitioning=true
    var tw:=create_tween()
    tw.tween_property(overlay,"color:a",1.0,0.45)
    tw.tween_callback(func(): get_tree().change_scene_to_file(LOBBY_SCENE))
