extends Node

signal player_joined(player: Node)

var players: Array[Node] = []


func register_player(player: Node) -> void:
	if players.has(player):
		return

	players.append(player)
	player_joined.emit(player)


func nearest_player_to(point: Vector2) -> Node:
	var nearest: Node = null
	var nearest_distance: float = INF
	for player in players:
		if not is_instance_valid(player):
			continue

		var player_position := Vector2.ZERO
		if player is Node2D:
			var player_2d := player as Node2D
			player_position = player_2d.global_position
		elif player is Node3D:
			var player_3d := player as Node3D
			player_position = Vector2(player_3d.global_position.x, player_3d.global_position.z)
		else:
			continue

		var distance: float = (player_position - point).length()
		if distance < nearest_distance:
			nearest = player
			nearest_distance = distance
	return nearest
