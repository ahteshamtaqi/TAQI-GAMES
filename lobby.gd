extends Control

const GAME_SCENE := "res://scenes/main.tscn"
var selected_map := 0
var selected_character := 0
var maps := ["TAQI ISLAND", "DESERT FRONT", "FROST VALLEY"]
var characters := ["RECON", "ASSAULT", "RANGER"]
var map_label: Label
var character_label: Label
var status_label: Label

func _ready() -> void:
    _build_ui()

func _build_ui() -> void:
    var bg := ColorRect.new()
    bg.color = Color(0.025,0.04,0.065,1)
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(bg)

    var header := Label.new()
    header.text = "TAQI GAMES"
    header.position = Vector2(32,18)
    header.add_theme_font_size_override("font_size",40)
    header.add_theme_color_override("font_color",Color(1.0,0.75,0.25))
    add_child(header)

    var tagline := Label.new()
    tagline.text = "PLAY  •  FIGHT  •  SURVIVE"
    tagline.position = Vector2(36,65)
    tagline.add_theme_font_size_override("font_size",16)
    tagline.add_theme_color_override("font_color",Color(0.82,0.87,0.94))
    add_child(tagline)

    var panel := PanelContainer.new()
    panel.anchor_left=0.05; panel.anchor_right=0.95
    panel.anchor_top=0.20; panel.anchor_bottom=0.86
    add_child(panel)
    var v := VBoxContainer.new()
    v.add_theme_constant_override("separation",16)
    panel.add_child(v)

    var welcome := Label.new()
    welcome.text="BATTLE LOBBY"
    welcome.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
    welcome.add_theme_font_size_override("font_size",30)
    welcome.add_theme_color_override("font_color",Color(1.0,0.79,0.38))
    v.add_child(welcome)

    var map_title := Label.new()
    map_title.text="SELECT MAP"
    map_title.add_theme_font_size_override("font_size",20)
    v.add_child(map_title)
    var map_row := HBoxContainer.new()
    v.add_child(map_row)
    for i in range(maps.size()):
        var b := Button.new()
        b.text=maps[i]
        b.size_flags_horizontal=Control.SIZE_EXPAND_FILL
        b.custom_minimum_size=Vector2(0,58)
        b.pressed.connect(func(): _select_map(i))
        map_row.add_child(b)
    map_label=Label.new()
    map_label.text="Selected map: " + maps[selected_map]
    v.add_child(map_label)

    var char_title := Label.new()
    char_title.text="SELECT CHARACTER"
    char_title.add_theme_font_size_override("font_size",20)
    v.add_child(char_title)
    var char_row := HBoxContainer.new()
    v.add_child(char_row)
    for i in range(characters.size()):
        var b := Button.new()
        b.text=characters[i]
        b.size_flags_horizontal=Control.SIZE_EXPAND_FILL
        b.custom_minimum_size=Vector2(0,58)
        b.pressed.connect(func(): _select_character(i))
        char_row.add_child(b)
    character_label=Label.new()
    character_label.text="Selected character: " + characters[selected_character]
    v.add_child(character_label)

    var start := Button.new()
    start.text="START MATCH"
    start.custom_minimum_size=Vector2(0,70)
    start.add_theme_font_size_override("font_size",26)
    start.add_theme_color_override("font_color",Color(0.08,0.08,0.08))
    start.add_theme_stylebox_override("normal",_gold_style())
    start.pressed.connect(_start_match)
    v.add_child(start)

    status_label=Label.new()
    status_label.text="OFFLINE PROTOTYPE • MAP/CHARACTER CHOICES ARE UI ONLY"
    status_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
    status_label.add_theme_font_size_override("font_size",14)
    status_label.add_theme_color_override("font_color",Color(0.68,0.74,0.82))
    v.add_child(status_label)

func _select_map(index: int) -> void:
    selected_map=index
    map_label.text="Selected map: " + maps[selected_map]
    status_label.text="Map selected: " + maps[selected_map]

func _select_character(index: int) -> void:
    selected_character=index
    character_label.text="Selected character: " + characters[selected_character]
    status_label.text="Character selected: " + characters[selected_character]

func _start_match() -> void:
    var err := get_tree().change_scene_to_file(GAME_SCENE)
    if err != OK:
        status_label.text="Could not open game scene (error %d)." % err

func _gold_style() -> StyleBoxFlat:
    var style := StyleBoxFlat.new()
    style.bg_color=Color(1.0,0.72,0.16)
    style.corner_radius_top_left=10
    style.corner_radius_top_right=10
    style.corner_radius_bottom_left=10
    style.corner_radius_bottom_right=10
    return style
