extends Area2D


@onready var interactable = $Interactable


func _on_body_entered(body):
	interactable.entered(body)


func _on_body_exited(body):
	interactable.exited(body)
