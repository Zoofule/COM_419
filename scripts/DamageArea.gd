extends Area2D

signal entityDamaged(entity)

export var playerDamage : float = 3
export var mechDamage : float = 1
onready var damage = [playerDamage, mechDamage]

var exceptions = []

func addException(node: Node):
	exceptions.append(node)

func removeException(node: Node):
	exceptions.erase(node)

func _on_DamageArea_area_entered(area):
	print(area.entity)
	if area is Hitbox:
		if !exceptions.has(area.entity) && area.entity.has_method("damage") && area.entity != $"..":
			emit_signal("entityDamaged", area.entity)
			area.entity.damage(damage)


