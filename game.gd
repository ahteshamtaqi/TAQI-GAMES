extends Node3D

# TAQI GAMES visual milestone: a more readable low-poly tactical character
# and a richer test arena. This is procedural art, not a rigged production asset.

func _ready() -> void:
    _make_world()
    _make_soldier()
    _make_hud()

func _mat(color: Color, roughness: float = 0.85) -> StandardMaterial3D:
    var m := StandardMaterial3D.new()
    m.albedo_color = color
    m.roughness = roughness
    return m

func _part(parent: Node3D, name: String, mesh: Mesh, pos: Vector3, mat: Material, rot: Vector3 = Vector3.ZERO) -> MeshInstance3D:
    var item := MeshInstance3D.new()
    item.name = name
    item.mesh = mesh
    item.position = pos
    item.rotation = rot
    item.material_override = mat
    parent.add_child(item)
    return item

func _box(size: Vector3) -> BoxMesh:
    var m := BoxMesh.new()
    m.size = size
    return m

func _capsule(radius: float, height: float) -> CapsuleMesh:
    var m := CapsuleMesh.new()
    m.radius = radius
    m.height = height
    return m

func _make_soldier() -> void:
    var player: Node3D = get_node("Player")
    # Hide the old two-piece placeholder; retain it in the scene for compatibility.
    get_node("Player/BodyMesh").visible = false
    get_node("Player/HeadMesh").visible = false
    var rig := Node3D.new()
    rig.name = "SoldierVisual"
    player.add_child(rig)

    var uniform := _mat(Color(0.19, 0.25, 0.18))
    var vest := _mat(Color(0.13, 0.16, 0.13))
    var trim := _mat(Color(0.38, 0.34, 0.22))
    var skin := _mat(Color(0.66, 0.43, 0.29))
    var helmet := _mat(Color(0.22, 0.29, 0.20))
    var boots := _mat(Color(0.075, 0.07, 0.055))
    var weapon := _mat(Color(0.075, 0.085, 0.075), 0.5)

    # Legs, boots, torso, tactical vest and shoulder pads.
    _part(rig, "LeftLeg", _capsule(0.14, 0.78), Vector3(-0.19, 0.48, 0), uniform)
    _part(rig, "RightLeg", _capsule(0.14, 0.78), Vector3(0.19, 0.48, 0), uniform)
    _part(rig, "LeftBoot", _box(Vector3(0.25, 0.14, 0.36)), Vector3(-0.19, 0.12, -0.07), boots)
    _part(rig, "RightBoot", _box(Vector3(0.25, 0.14, 0.36)), Vector3(0.19, 0.12, -0.07), boots)
    _part(rig, "Torso", _capsule(0.31, 0.78), Vector3(0, 1.25, 0), uniform)
    _part(rig, "Vest", _box(Vector3(0.57, 0.48, 0.35)), Vector3(0, 1.31, -0.025), vest)
    for x in [-0.17, 0.0, 0.17]:
        _part(rig, "MagazinePouch", _box(Vector3(0.105, 0.16, 0.09)), Vector3(x, 1.22, -0.22), trim)
    _part(rig, "Belt", _box(Vector3(0.48, 0.09, 0.34)), Vector3(0, 0.99, 0), trim)
    _part(rig, "Neck", _capsule(0.105, 0.18), Vector3(0, 1.72, 0), skin)
    _part(rig, "Head", _capsule(0.19, 0.42), Vector3(0, 1.94, 0), skin)
    _part(rig, "Helmet", _capsule(0.225, 0.25), Vector3(0, 2.12, 0.005), helmet)
    _part(rig, "HelmetRim", _box(Vector3(0.47, 0.045, 0.40)), Vector3(0, 2.055, -0.015), helmet)
    _part(rig, "Backpack", _box(Vector3(0.38, 0.48, 0.22)), Vector3(0, 1.38, 0.25), vest)
    _part(rig, "LeftShoulder", _capsule(0.15, 0.28), Vector3(-0.39, 1.51, 0), uniform, Vector3(0, 0, -0.7))
    _part(rig, "RightShoulder", _capsule(0.15, 0.28), Vector3(0.39, 1.51, 0), uniform, Vector3(0, 0, 0.7))
    _part(rig, "LeftArm", _capsule(0.105, 0.58), Vector3(-0.43, 1.20, -0.07), uniform, Vector3(0, 0, -0.22))
    _part(rig, "RightArm", _capsule(0.105, 0.58), Vector3(0.43, 1.20, -0.10), uniform, Vector3(0, 0, 0.22))
    _part(rig, "LeftGlove", _capsule(0.075, 0.14), Vector3(-0.49, 0.92, -0.16), boots)
    _part(rig, "RightGlove", _capsule(0.075, 0.14), Vector3(0.49, 0.92, -0.20), boots)
    # Low-poly rifle silhouette held across the front.
    _part(rig, "RifleBody", _box(Vector3(0.12, 0.12, 0.72)), Vector3(0.13, 1.12, -0.38), weapon, Vector3(0.08, 0, -0.16))
    _part(rig, "RifleBarrel", _box(Vector3(0.055, 0.055, 0.42)), Vector3(0.13, 1.15, -0.88), weapon)
    _part(rig, "RifleStock", _box(Vector3(0.10, 0.14, 0.20)), Vector3(0.13, 1.10, -0.03), weapon)
    _part(rig, "Optic", _box(Vector3(0.09, 0.08, 0.12)), Vector3(0.13, 1.22, -0.39), trim)

func _make_world() -> void:
    var grass := _mat(Color(0.24, 0.34, 0.19))
    get_node("Ground/GroundMesh").material_override = grass
    var rng := RandomNumberGenerator.new()
    rng.randomize()
    for i in range(64):
        var p := Vector3(rng.randf_range(-44, 44), 0, rng.randf_range(-44, 44))
        if Vector2(p.x, p.z).length() > 10:
            _add_tree(p, rng.randf_range(0.75, 1.45), rng)
    for i in range(18):
        var p := Vector3(rng.randf_range(-42, 42), 0, rng.randf_range(-42, 42))
        if Vector2(p.x, p.z).length() > 9:
            _add_rock(p, rng.randf_range(0.55, 1.5), rng)
    _add_building(Vector3(-13, 0, -17), Vector3(7, 3.2, 6))
    _add_building(Vector3(17, 0, 13), Vector3(8, 3.8, 7))
    _add_building(Vector3(-27, 0, 19), Vector3(5, 2.7, 5))
    _add_crates(Vector3(5, 0, -8))

func _add_tree(pos: Vector3, s: float, rng: RandomNumberGenerator) -> void:
    var tree := Node3D.new()
    tree.position = pos
    tree.scale = Vector3.ONE * s
    add_child(tree)
    _part(tree, "Trunk", CylinderMesh.new(), Vector3(0, 0.95, 0), _mat(Color(0.25, 0.15, 0.08)))
    var trunk: CylinderMesh = tree.get_node("Trunk").mesh
    trunk.top_radius = 0.13
    trunk.bottom_radius = 0.24
    trunk.height = 1.9
    for j in range(3):
        var crown := _part(tree, "Canopy", SphereMesh.new(), Vector3(rng.randf_range(-0.25, 0.25), 1.9 + j * 0.38, rng.randf_range(-0.2, 0.2)), _mat(Color(0.10 + rng.randf_range(0, 0.05), 0.23 + rng.randf_range(0, 0.08), 0.10)))
        crown.scale = Vector3(0.75 - j * 0.09, 0.85 - j * 0.08, 0.75 - j * 0.09)

func _add_rock(pos: Vector3, s: float, rng: RandomNumberGenerator) -> void:
    var rock := _part(self, "Rock", SphereMesh.new(), pos + Vector3(0, 0.35 * s, 0), _mat(Color(0.31, 0.33, 0.29)))
    rock.scale = Vector3(s, s * rng.randf_range(0.45, 0.8), s * rng.randf_range(0.7, 1.2))

func _add_building(pos: Vector3, size: Vector3) -> void:
    var building := StaticBody3D.new()
    building.position = pos + Vector3(0, size.y * 0.5, 0)
    add_child(building)
    var wall := _part(building, "BuildingMesh", _box(size), Vector3.ZERO, _mat(Color(0.43, 0.42, 0.34)))
    var collision := CollisionShape3D.new()
    var shape := BoxShape3D.new()
    shape.size = size
    collision.shape = shape
    building.add_child(collision)
    # Dark doorway and window panels create readable depth from the gameplay camera.
    _part(building, "Door", _box(Vector3(size.x * 0.18, size.y * 0.63, 0.06)), Vector3(0, -size.y * 0.18, -size.z * 0.51), _mat(Color(0.10, 0.12, 0.11)))
    _part(building, "WindowA", _box(Vector3(size.x * 0.17, size.y * 0.2, 0.06)), Vector3(-size.x * 0.28, size.y * 0.12, -size.z * 0.51), _mat(Color(0.12, 0.20, 0.22)))
    _part(building, "WindowB", _box(Vector3(size.x * 0.17, size.y * 0.2, 0.06)), Vector3(size.x * 0.28, size.y * 0.12, -size.z * 0.51), _mat(Color(0.12, 0.20, 0.22)))

func _add_crates(pos: Vector3) -> void:
    for i in range(4):
        var crate := _part(self, "SupplyCrate", _box(Vector3(0.9, 0.8, 0.9)), pos + Vector3((i % 2) * 1.0, 0.4, int(i / 2) * 1.0), _mat(Color(0.40, 0.31, 0.17)))
        crate.rotation.y = float(i) * 0.12

func _make_hud() -> void:
    var layer: CanvasLayer = get_node("HUD")
    var title := Label.new()
    title.text = "TAQI GAMES  |  SURVIVE THE DROP"
    title.position = Vector2(24, 18)
    title.add_theme_font_size_override("font_size", 24)
    title.add_theme_color_override("font_color", Color(1.0, 0.82, 0.38))
    layer.add_child(title)
    var status := Label.new()
    status.text = "TRAINING ISLAND  •  SOLO TEST BUILD"
    status.position = Vector2(26, 52)
    status.add_theme_font_size_override("font_size", 15)
    status.add_theme_color_override("font_color", Color(0.93, 0.96, 0.90))
    layer.add_child(status)
    var crosshair := Label.new()
    crosshair.text = "+"
    crosshair.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
    crosshair.position = Vector2(-8, -15)
    crosshair.add_theme_font_size_override("font_size", 28)
    crosshair.add_theme_color_override("font_color", Color(1, 1, 1, 0.85))
    layer.add_child(crosshair)
    var jump := Button.new()
    jump.text = "JUMP"
    jump.anchor_left = 1.0
    jump.anchor_right = 1.0
    jump.anchor_top = 1.0
    jump.anchor_bottom = 1.0
    jump.offset_left = -170
    jump.offset_right = -28
    jump.offset_top = -125
    jump.offset_bottom = -28
    jump.add_theme_font_size_override("font_size", 22)
    layer.add_child(jump)
    jump.button_down.connect(func(): get_node("Player").touch_jump = true)
    jump.button_up.connect(func(): get_node("Player").touch_jump = false)
    var hint := Label.new()
    hint.text = "WASD / ARROWS: MOVE   •   SPACE: JUMP   •   RIGHT DRAG: LOOK"
    hint.position = Vector2(24, 680)
    hint.add_theme_font_size_override("font_size", 14)
    hint.add_theme_color_override("font_color", Color(0.94, 0.94, 0.88))
    layer.add_child(hint)
