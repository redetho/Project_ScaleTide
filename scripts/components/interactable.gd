class_name Interactable
extends Area3D

@export var interaction_name := "Interação"
@export_multiline var description := ""


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func interact(player: Node) -> void:
	print("%s interagiu com %s: %s" % [player.name, interaction_name, description])
	QuestManager.start_quest(interaction_name.to_snake_case(), {"source": name})


func _on_body_entered(body: Node) -> void:
	if body.has_method("register_interactable"):
		body.register_interactable(self)


func _on_body_exited(body: Node) -> void:
	if body.has_method("unregister_interactable"):
		body.unregister_interactable(self)
