extends Node3D

@onready var world_root: Node3D = $World
@onready var player_root: Node3D = $PlayerRoot
@onready var hud_layer: CanvasLayer = $HUD
@onready var camera_rig: Node3D = $CameraRig
@onready var camera: Camera3D = $CameraRig/PlayerCamera
@onready var sun_light: DirectionalLight3D = $Sun
@onready var fill_light: DirectionalLight3D = $SoftFill
@onready var world_environment_node: WorldEnvironment = $WorldEnvironment
@onready var player_one: PlayerController = $PlayerRoot/Player1

var hud_label: Label
var hint_label: Label
var tide_overlay: ColorRect
var world_environment: Environment
var camera_follow_speed := 24.0


func _ready() -> void:
	world_environment = world_environment_node.environment
	camera.look_at(camera_rig.global_position, Vector3.UP)
	CoopManager.register_player(player_one)
	_build_hud()
	_wire_global_signals()
	GameState.change_phase(GameState.GamePhase.EXPLORATION)


func _physics_process(delta: float) -> void:
	_update_camera(delta)


func _process(_delta: float) -> void:
	_update_lighting()
	_update_hud()


func _wire_global_signals() -> void:
	TimeManager.day_started.connect(_on_day_started)
	TimeManager.night_started.connect(_on_night_started)
	TideManager.tide_changed.connect(_on_tide_changed)


func _build_hud() -> void:
	tide_overlay = ColorRect.new()
	tide_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	tide_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud_layer.add_child(tide_overlay)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 14)
	hud_layer.add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 8)
	margin.add_child(root)

	hud_label = Label.new()
	hud_label.add_theme_font_size_override("font_size", 18)
	root.add_child(hud_label)

	hint_label = Label.new()
	hint_label.add_theme_font_size_override("font_size", 13)
	hint_label.modulate = Color(0.92, 0.94, 1.0, 0.92)
	hint_label.text = "WASD move | E interage | Q melodia | Shift rola | Space pula | clique esquerdo ataca"
	root.add_child(hint_label)


func _update_hud() -> void:
	var time_name := "Dia" if TimeManager.is_daytime() else "Noite"
	var tide_name := TideManager.current_tide.display_name
	hud_label.text = "%s %.0f%% | Mare: %s %.0f%% | Vila: %s | Fase: %s" % [
		time_name,
		TimeManager.day_progress * 100.0,
		tide_name,
		_normalized_tide_level() * 100.0,
		VillageManager.stage_name(),
		GameState.phase_name()
	]

	var overlay_color := TideManager.current_tide.overlay_color
	overlay_color.a *= _normalized_tide_level()
	tide_overlay.color = overlay_color


func _update_camera(delta: float) -> void:
	if camera_rig == null or player_one == null:
		return

	var follow_weight := 1.0 - exp(-camera_follow_speed * delta)
	camera_rig.global_position = camera_rig.global_position.lerp(player_one.global_position, follow_weight)


func _update_lighting() -> void:
	if sun_light == null or fill_light == null or world_environment == null:
		return

	var hour := TimeManager.day_progress * 24.0
	var daylight := 0.0
	if hour >= 6.0 and hour <= 18.0:
		daylight = sin(((hour - 6.0) / 12.0) * PI)

	var night_color := Color("26314f")
	var day_color := Color("9fc6d0")
	var night_ambient := Color("62709b")
	var day_ambient := Color("d4e6df")

	world_environment.background_color = night_color.lerp(day_color, daylight)
	world_environment.ambient_light_color = night_ambient.lerp(day_ambient, daylight)
	world_environment.ambient_light_energy = lerpf(0.38, 1.15, daylight)

	sun_light.light_energy = lerpf(0.04, 1.05, daylight)
	fill_light.light_energy = lerpf(0.12, 0.28, daylight)
	sun_light.rotation_degrees = Vector3(lerpf(-34.0, -64.0, daylight), -28.0 + hour * 3.0, 0.0)


func _normalized_tide_level() -> float:
	if TideManager.max_tide_level <= 0.0:
		return 0.0

	return clampf(TideManager.tide_level / TideManager.max_tide_level, 0.0, 1.0)


func _on_day_started(_day: int) -> void:
	TideManager.clear_tide()


func _on_night_started(_day: int) -> void:
	TideManager.roll_night_tide()


func _on_tide_changed(_tide_data: TideData) -> void:
	pass
