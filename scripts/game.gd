extends Node3D

func _ready() -> void:
    _make_world()
    _make_hud()

func _make_world() -> void:
    var grass := StandardMaterial3D.new()
    grass.albedo_color = Color(0.18, 0.42, 0.2)
    get_node("Ground/GroundMesh").material_override = grass

    var uniform := StandardMaterial3D.new()
    uniform.albedo_color = Color(0.12, 0.2, 0.42)
    get_node("Player/BodyMesh").material_override = uniform

    var skin := StandardMaterial3D.new()
    skin.albedo_color = Color(0.78, 0.57, 0.4)
    get_node("Player/HeadMesh").material_override = skin

    var rng := RandomNumberGenerator.new()
    rng.randomize()
    for i in range(38):
        var p := Vector3(rng.randf_range(-38, 38), 0, rng.randf_range(-38, 38))
        if Vector2(p.x, p.z).length() > 8:
            _add_tree(p, rng.randf_range(0.7, 1.4))

func _add_tree(pos: Vector3, tree_scale: float) -> void:
    var tree := Node3D.new()
    tree.position = pos
    tree.scale = Vector3.ONE * tree_scale
    add_child(tree)

    var trunk := MeshInstance3D.new()
    var trunk_mesh := CylinderMesh.new()
    trunk_mesh.top_radius = 0.18
    trunk_mesh.bottom_radius = 0.25
    trunk_mesh.height = 1.8
    trunk.mesh = trunk_mesh
    trunk.position.y = 0.9
    var bark := StandardMaterial3D.new()
    bark.albedo_color = Color(0.28, 0.16, 0.08)
    trunk.material_override = bark
    tree.add_child(trunk)

    var crown := MeshInstance3D.new()
    var crown_mesh := SphereMesh.new()
    crown_mesh.radius = 0.9
    crown_mesh.height = 1.8
    crown.mesh = crown_mesh
    crown.position.y = 2.1
    var leaves := StandardMaterial3D.new()
    leaves.albedo_color = Color(0.1, 0.31, 0.12)
    crown.material_override = leaves
    tree.add_child(crown)

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
    pad.color = Color(0.08, 0.1, 0.14, 0.48)
    layer.add_child(pad)

    var jump := Button.new()
    jump.text = "JUMP"
    jump.position = Vector2(1070, 565)
    jump.size = Vector2(150, 90)
    jump.add_theme_font_size_override("font_size", 22)
    layer.add_child(jump)
    jump.button_down.connect(func(): get_node("Player").touch_jump = true)
    jump.button_up.connect(func(): get_node("Player").touch_jump = false)

    var note := Label.new()
    note.text = "EARLY PROTOTYPE — features will be added in stages"
    note.position = Vector2(22, 678)
    note.add_theme_font_size_override("font_size", 14)
    layer.add_child(note)
