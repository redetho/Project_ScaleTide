class_name PlayerController
extends CharacterBody3D

@export var player_index := 1
@export var move_speed := 4.2
@export var run_speed := 6.4
@export var roll_speed := 11.5
@export var roll_duration := 0.18
@export var roll_cooldown := 0.42
@export var run_trail_interval := 0.09
@export var jump_velocity := 6.3
@export var gravity := 18.0
@export var shadow_max_air_height := 2.4
@export var normal_attack_lock := 0.28
@export var dash_attack_extra_lock := 0.5
@export var dash_attack_window := 0.28
@export var dash_effect_scene: PackedScene = preload("res://scenes/effects/dash_effect.tscn")
@export var run_trail_effect_scene: PackedScene = preload("res://scenes/effects/run_trail_effect.tscn")
@export var attack_effect_scene: PackedScene = preload("res://scenes/effects/attack_effect.tscn")
@export var dash_attack_effect_scene: PackedScene = preload("res://scenes/effects/dash_attack_effect.tscn")

var nearby_interactables: Array[Area3D] = []
var _visual_pivot: Node3D
var _body: MeshInstance3D
var _shadow: MeshInstance3D
var _facing_direction := Vector3.FORWARD
var _attack_cooldown := 0.0
var _attack_lock_timer := 0.0
var _roll_timer := 0.0
var _roll_cooldown_timer := 0.0
var _dash_attack_window_timer := 0.0
var _run_trail_timer := 0.0
var _can_run_after_dash := false
var _roll_direction := Vector3.FORWARD
var _last_ground_y := 0.0
var _shadow_ground_offset := 0.035
var _shadow_base_scale := Vector3.ONE


func _ready() -> void:
	_ensure_player_inputs()
	_visual_pivot = $VisualPivot
	_body = $VisualPivot/Body
	_shadow = $Shadow
	_shadow_base_scale = _shadow.scale
	_last_ground_y = global_position.y


func _physics_process(delta: float) -> void:
	_attack_cooldown = maxf(0.0, _attack_cooldown - delta)
	_attack_lock_timer = maxf(0.0, _attack_lock_timer - delta)
	_roll_cooldown_timer = maxf(0.0, _roll_cooldown_timer - delta)
	_dash_attack_window_timer = maxf(0.0, _dash_attack_window_timer - delta)
	_run_trail_timer = maxf(0.0, _run_trail_timer - delta)

	if not is_on_floor():
		velocity.y -= gravity * delta
	elif velocity.y < 0.0:
		velocity.y = -0.1

	var prefix := "p%d" % player_index
	var input_vector := Input.get_vector(
		"%s_move_left" % prefix,
		"%s_move_right" % prefix,
		"%s_move_up" % prefix,
		"%s_move_down" % prefix
	)
	var move_direction := Vector3(input_vector.x, 0.0, input_vector.y)
	if move_direction.length_squared() > 0.01:
		_facing_direction = move_direction.normalized()

	var wants_run := _can_run_after_dash and Input.is_action_pressed("%s_roll" % prefix)
	var is_moving := move_direction.length_squared() > 0.01
	if _attack_lock_timer > 0.0:
		_roll_timer = 0.0
		_can_run_after_dash = false
		velocity.x = 0.0
		velocity.z = 0.0
	elif _roll_timer > 0.0:
		_roll_timer -= delta
		velocity.x = _roll_direction.x * roll_speed
		velocity.z = _roll_direction.z * roll_speed
	elif wants_run and is_moving:
		velocity.x = move_direction.x * run_speed
		velocity.z = move_direction.z * run_speed
		_spawn_run_trail_if_ready()
	else:
		if not Input.is_action_pressed("%s_roll" % prefix):
			_can_run_after_dash = false
		velocity.x = move_direction.x * move_speed
		velocity.z = move_direction.z * move_speed

	move_and_slide()
	if is_on_floor():
		_last_ground_y = global_position.y
	_update_air_visuals()


func _process(_delta: float) -> void:
	var prefix := "p%d" % player_index
	if Input.is_action_just_pressed("%s_interact" % prefix):
		_try_interact()
	if Input.is_action_just_pressed("%s_melody" % prefix):
		_play_context_melody()
	if Input.is_action_just_pressed("%s_attack" % prefix):
		_attack()
	if Input.is_action_just_pressed("%s_roll" % prefix):
		_roll()
	if Input.is_action_just_pressed("%s_jump" % prefix):
		_jump()


func register_interactable(interactable: Area3D) -> void:
	if not nearby_interactables.has(interactable):
		nearby_interactables.append(interactable)


func unregister_interactable(interactable: Area3D) -> void:
	nearby_interactables.erase(interactable)


func _try_interact() -> void:
	var target := _nearest_interactable()
	if target == null:
		return

	if target.has_method("interact"):
		target.interact(self)


func _play_context_melody() -> void:
	AudioDirector.play_melody("melodia_do_dorso")
	InventoryManager.add_item("eco_melodico", 1)


func _attack() -> void:
	if _attack_cooldown > 0.0:
		return

	var is_dash_attack := _roll_timer > 0.0 or _dash_attack_window_timer > 0.0
	var attack_lock := normal_attack_lock
	_roll_timer = 0.0
	_can_run_after_dash = false

	if is_dash_attack:
		attack_lock += dash_attack_extra_lock
		_attack_cooldown = attack_lock
		_attack_lock_timer = attack_lock
		_spawn_dash_attack_effect()
	else:
		_attack_cooldown = attack_lock
		_attack_lock_timer = attack_lock
		_spawn_attack_effect()


func _roll() -> void:
	if _roll_cooldown_timer > 0.0 or _attack_lock_timer > 0.0:
		return

	var move_vector := Input.get_vector("p1_move_left", "p1_move_right", "p1_move_up", "p1_move_down")
	var move_direction := Vector3(move_vector.x, 0.0, move_vector.y)
	_roll_direction = move_direction.normalized() if move_direction.length_squared() > 0.01 else _facing_direction
	_facing_direction = _roll_direction
	_roll_timer = roll_duration
	_roll_cooldown_timer = roll_cooldown
	_dash_attack_window_timer = roll_duration + dash_attack_window
	_can_run_after_dash = true
	_spawn_roll_effect()


func _jump() -> void:
	if not is_on_floor() or _roll_timer > 0.0 or _attack_lock_timer > 0.0:
		return

	velocity.y = jump_velocity


func _update_air_visuals() -> void:
	var air_scale := 1.0
	if not is_on_floor():
		air_scale = 1.12

	_visual_pivot.scale = _visual_pivot.scale.lerp(Vector3.ONE * air_scale, 0.2)

	var ground_y := _ground_y_below()
	var air_height := maxf(0.0, global_position.y - ground_y)
	var height_ratio := clampf(air_height / shadow_max_air_height, 0.0, 1.0)
	var shadow_radius := lerpf(1.0, 0.38, height_ratio)
	var target_shadow_scale := Vector3(shadow_radius, 1.0, shadow_radius)

	_shadow.scale = _shadow.scale.lerp(_shadow_base_scale * target_shadow_scale, 0.35)


func _ground_y_below() -> float:
	var ray_start := global_position + Vector3.UP * 0.2
	var ray_end := global_position + Vector3.DOWN * 8.0
	var query := PhysicsRayQueryParameters3D.create(ray_start, ray_end)
	query.exclude = [get_rid()]

	var hit := get_world_3d().direct_space_state.intersect_ray(query)
	if hit.has("position"):
		_last_ground_y = (hit["position"] as Vector3).y

	return _last_ground_y


func _spawn_roll_effect() -> void:
	if dash_effect_scene == null:
		return

	var effect := dash_effect_scene.instantiate() as Node3D
	effect.position = Vector3(0, 0.05, 0) - _roll_direction * 0.35
	effect.rotation.y = atan2(_roll_direction.x, _roll_direction.z)
	add_child(effect)


func _spawn_run_trail_if_ready() -> void:
	if run_trail_effect_scene == null or _run_trail_timer > 0.0:
		return

	_run_trail_timer = run_trail_interval
	var effect := run_trail_effect_scene.instantiate() as Node3D
	effect.position = Vector3(0, 0.04, 0) - _facing_direction * 0.28
	effect.rotation.y = atan2(_facing_direction.x, _facing_direction.z)
	add_child(effect)


func _spawn_attack_effect() -> void:
	if attack_effect_scene == null:
		return

	var effect := attack_effect_scene.instantiate() as Node3D
	effect.position = Vector3(0, 0.45, 0) + _facing_direction * 0.62
	effect.rotation.y = atan2(_facing_direction.x, _facing_direction.z)
	add_child(effect)


func _spawn_dash_attack_effect() -> void:
	if dash_attack_effect_scene == null:
		return

	var effect := dash_attack_effect_scene.instantiate() as Node3D
	effect.position = Vector3(0, 0.45, 0) + _facing_direction * 1.15
	effect.rotation.y = atan2(_facing_direction.x, _facing_direction.z)
	add_child(effect)


func _ensure_player_inputs() -> void:
	if not InputMap.has_action("p1_attack"):
		InputMap.add_action("p1_attack")

		var mouse := InputEventMouseButton.new()
		mouse.button_index = MOUSE_BUTTON_LEFT
		InputMap.action_add_event("p1_attack", mouse)

	if not InputMap.has_action("p1_roll"):
		InputMap.add_action("p1_roll")

		var roll_key := InputEventKey.new()
		roll_key.keycode = KEY_SHIFT
		InputMap.action_add_event("p1_roll", roll_key)

	if not InputMap.has_action("p1_jump"):
		InputMap.add_action("p1_jump")

		var jump_key := InputEventKey.new()
		jump_key.keycode = KEY_SPACE
		InputMap.action_add_event("p1_jump", jump_key)


func _nearest_interactable() -> Area3D:
	var nearest: Area3D = null
	var nearest_distance: float = INF
	for interactable in nearby_interactables:
		if not is_instance_valid(interactable):
			continue

		var distance: float = global_position.distance_to(interactable.global_position)
		if distance < nearest_distance:
			nearest = interactable
			nearest_distance = distance
	return nearest
