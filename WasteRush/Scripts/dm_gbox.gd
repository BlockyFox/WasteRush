extends Area2D


var damage = 15

func _on_mop_head_change_dmg(dmg: Variant) -> void:
	damage = dmg
	
func _on_body_entered(body: Node2D) -> void:
	if "health" in body:
		body.health -= damage
