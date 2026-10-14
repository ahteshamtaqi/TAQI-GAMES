extends Node3D

const SOLDIER_MODEL_PATH := "res://assets/characters/character-soldier.glb"
const SOLDIER_TEXTURE_PATH := "res://assets/characters/Textures/colormap.png"

func _ready() -> void:
    _setup_materials()
    _spawn_character_visual()
    _make_world()
    _make_hud()

func _setup_materials() -> void:
    var ground_mat := StandardMaterial3D.new()
    ground_mat.albedo_color = Color(0.24, 0.39, 0.20)
    ground_mat.roughness = 1.0
    get_node("Ground/GroundMesh").material_override = ground_mat

func _spawn_character_visual() -> void:
    var holder: Node3D = get_node("Player/CharacterVisual")
    # If the real GLB has been uploaded, use it. The fallback is intentionally
    # detailed enough to avoid the original capsule-only placeholder.
    if ResourceLoader.exists(SOLDIER_MODEL_PATH):
        var packed := load(SOLDIER_MODEL_PATH) as PackedScene
        if packed:
            var model := packed.instantiate()
            holder.add_child(model)
            model.scale = Vector3.ONE * 1.65
            model.position.y = 0.0
            return
    _make_fallback_soldier(holder)

func _make_fallback_soldier(holder: Node3D) -> void:
    var uniform := _mat(Color(0.16, 0.22, 0.17))
    var vest := _mat(Color(0.30, 0.27, 0.18))
    var skin := _mat(Color(0.58, 0.39, 0.27))
    var dark := _mat(Color(0.075, 0.085, 0.075))
    var helmet := _mat(Color(0.12, 0.18, 0.13))
    _add_box(holder, Vector3(0, 0.88, 0), Vector3(0.58, 0.66, 0.30), uniform)
    _add_box(holder, Vector3(0, 0.92, -0.19), Vector3(0.42, 0.46, 0.12), vest)
    _add_box(holder, Vector3(0, 0.93, -0.265), Vector3(0.31, 0.24, 0.035), _mat(Color(0.39,0.35,0.23)))
    _add_sphere(holder, Vector3(0, 1.43, 0), Vector3(0.23,0.26,0.22), skin)
    _add_sphere(holder, Vector3(0, 1.59, 0), Vector3(0.25,0.16,0.24), helmet)
    _add_box(holder, Vector3(0, 1.48, -0.20), Vector3(0.28,0.055,0.04), dark)
    # arms, gloves, legs and boots
    _add_box(holder, Vector3(-0.39,0.91,-0.01), Vector3(0.18,0.53,0.20), uniform, Vector3(0,0,-0.12))
    _add_box(holder, Vector3(0.39,0.91,-0.01), Vector3(0.18,0.53,0.20), uniform, Vector3(0,0,0.12))
    _add_sphere(holder, Vector3(-0.42,0.62,-0.02), Vector3(0.12,0.10,0.12), dark)
    _add_sphere(holder, Vector3(0.42,0.62,-0.02), Vector3(0.12,0.10,0.12), dark)
    _add_box(holder, Vector3(-0.17,0.36,0.01), Vector3(0.22,0.54,0.25), uniform)
    _add_box(holder, Vector3(0.17,0.36,0.01), Vector3(0.22,0.54,0.25), uniform)
    _add_box(holder, Vector3(-0.17,0.08,-0.06), Vector3(0.24,0.16,0.38), dark)
    _add_box(holder, Vector3(0.17,0.08,-0.06), Vector3(0.24,0.16,0.38), dark)
    # compact rifle silhouette across the chest
    _add_box(holder, Vector3(0.25,0.83,-0.25), Vector3(0.10,0.09,0.68), dark, Vector3(0.0,0.0,-0.30))
    _add_box(holder, Vector3(0.20,0.73,-0.19), Vector3(0.10,0.22,0.12), dark)

func _mat(color: Color) -> StandardMaterial3D:
    var m := StandardMaterial3D.new()
    m.albedo_color = color
    m.roughness = 0.88
    return m

func _add_box(parent: Node3D, pos: Vector3, size: Vector3, material: Material, rot: Vector3 = Vector3.ZERO) -> void:
    var node := MeshInstance3D.new()
    var mesh := BoxMesh.new()
    mesh.size = size
    node.mesh = mesh
    node.position = pos
    node.rotation = rot
    node.material_override = material
    parent.add_child(node)

func _add_sphere(parent: Node3D, pos: Vector3, size: Vector3, material: Material) -> void:
    var node := MeshInstance3D.new()
    var mesh := SphereMesh.new()
    mesh.radius = 0.5
    mesh.height = 1.0
    node.mesh = mesh
    node.position = pos
    node.scale = size
    node.material_override = material
    parent.add_child(node)

func _make_world() -> void:
    var rng := RandomNumberGenerator.new()
    rng.randomize()
    # Layered conifer and broadleaf trees for a less empty skyline.
    for i in range(70):
        var p := Vector3(rng.randf_range(-44, 44), 0, rng.randf_range(-44, 44))
        if Vector2(p.x, p.z).length() > 9:
            _add_tree(p, rng.randf_range(0.75, 1.55), rng)
    for i in range(22):
        var p := Vector3(rng.randf_range(-36, 36), 0, rng.randf_range(-36, 36))
        if Vector2(p.x, p.z).length() > 7:
            _add_rock(p, rng.randf_range(0.45, 1.4), rng)
    _add_building(Vector3(13,0,-13), Vector3(7,3.2,6), Color(0.48,0.43,0.34))
    _add_building(Vector3(-16,0,-18), Vector3(8,3.5,7), Color(0.39,0.43,0.38))
    _add_building(Vector3(19,0,15), Vector3(6,2.8,6), Color(0.51,0.48,0.40))
    for i in range(8):
        _add_crate(Vector3(10 + (i % 4)*1.2,0.55,-6 + int(i/4)*1.2))

func _add_tree(pos: Vector3, s: float, rng: RandomNumberGenerator) -> void:
    var tree := Node3D.new()
    tree.position = pos
    tree.scale = Vector3.ONE * s
    add_child(tree)
    var trunk := MeshInstance3D.new()
    var trunk_mesh := CylinderMesh.new()
    trunk_mesh.top_radius = 0.13
    trunk_mesh.bottom_radius = 0.24
    trunk_mesh.height = 1.9
    trunk.mesh = trunk_mesh
    trunk.position.y = 0.95
    trunk.material_override = _mat(Color(0.25,0.15,0.085))
    tree.add_child(trunk)
    for j in range(3):
        var crown := MeshInstance3D.new()
        var crown_mesh := ConeMesh.new()
        crown_mesh.top_radius = 0.0
        crown_mesh.bottom_radius = 1.05 - j*0.16
        crown_mesh.height = 1.5
        crown.mesh = crown_mesh
        crown.position.y = 1.75 + j*0.72
        crown.material_override = _mat(Color(0.08 + rng.randf()*0.05,0.23 + rng.randf()*0.08,0.10))
        tree.add_child(crown)

func _add_rock(pos: Vector3, s: float, rng: RandomNumberGenerator) -> void:
    var rock := MeshInstance3D.new()
    var mesh := SphereMesh.new()
    mesh.radius = 0.55
    mesh.height = 0.85
    rock.mesh = mesh
    rock.position = pos + Vector3(0,0.28*s,0)
    rock.scale = Vector3(s*1.2,s*0.65,s)
    rock.rotation.y = rng.randf_range(0,TAU)
    rock.material_override = _mat(Color(0.28,0.30,0.27))
    add_child(rock)

func _add_building(pos: Vector3, size: Vector3, color: Color) -> void:
    var root := StaticBody3D.new()
    root.position = pos + Vector3(0,size.y/2,0)
    add_child(root)
    var body := MeshInstance3D.new()
    var mesh := BoxMesh.new()
    mesh.size = size
    body.mesh = mesh
    body.material_override = _mat(color)
    root.add_child(body)
    var collision := CollisionShape3D.new()
    var shape := BoxShape3D.new()
    shape.size = size
    collision.shape = shape
    root.add_child(collision)
    # dark window panels on the visible front face
    for side in [-1,1]:
        var window := MeshInstance3D.new()
        var wm := BoxMesh.new()
        wm.size = Vector3(1.0,0.85,0.08)
        window.mesh = wm
        window.position = Vector3(side*size.x*0.22,0.25,-size.z/2-0.05)
        window.material_override = _mat(Color(0.055,0.10,0.13))
        root.add_child(window)
    var roof := MeshInstance3D.new()
    var rm := BoxMesh.new()
    rm.size = Vector3(size.x+0.35,0.18,size.z+0.35)
    roof.mesh = rm
    roof.position.y = size.y/2+0.08
    roof.material_override = _mat(Color(0.20,0.22,0.20))
    root.add_child(roof)

func _add_crate(pos: Vector3) -> void:
    var crate := MeshInstance3D.new()
    var mesh := BoxMesh.new()
    mesh.size = Vector3(0.9,1.1,0.9)
    crate.mesh = mesh
    crate.position = pos
    crate.material_override = _mat(Color(0.38,0.29,0.16))
    add_child(crate)

func _make_hud() -> void:
    var layer: CanvasLayer = get_node("HUD")
    var title := Label.new()
    title.text = "TAQI GAMES  |  PLAY • FIGHT • SURVIVE"
    title.position = Vector2(22, 18)
    title.add_theme_font_size_override("font_size", 24)
    title.add_theme_color_override("font_color", Color(1.0, 0.82, 0.38))
    layer.add_child(title)
    var help := Label.new()
    help.text = "MOVE: WASD / ARROWS  •  JUMP: SPACE  •  TOUCH: DRAG LEFT SIDE + JUMP"
    help.position = Vector2(22, 52)
    help.add_theme_font_size_override("font_size", 15)
    help.add_theme_color_override("font_color", Color.WHITE)
    layer.add_child(help)
    var pad := ColorRect.new()
    pad.position = Vector2(28, 510)
    pad.size = Vector2(150, 150)
    pad.color = Color(0.08, 0.1, 0.14, 0.32)
    layer.add_child(pad)
    var jump := Button.new()
    jump.text = "JUMP"
    jump.anchor_left = 1.0
    jump.anchor_right = 1.0
    jump.offset_left = -175
    jump.offset_right = -28
    jump.anchor_top = 1.0
    jump.anchor_bottom = 1.0
    jump.offset_top = -135
    jump.offset_bottom = -35
    jump.add_theme_font_size_override("font_size", 22)
    layer.add_child(jump)
    jump.button_down.connect(func(): get_node("Player").touch_jump = true)
    jump.button_up.connect(func(): get_node("Player").touch_jump = false)
    var note := Label.new()
    note.text = "VISUAL MILESTONE 1  •  MODEL ASSET CAN BE DROPPED INTO assets/characters"
    note.position = Vector2(22, 82)
    note.add_theme_font_size_override("font_size", 14)
    note.add_theme_color_override("font_color", Color(0.92,0.95,0.98))
    layer.add_child(note)
