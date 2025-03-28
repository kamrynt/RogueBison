extends CharacterBody2D
class_name ItemBase

@export var parent: CharacterBody2D = null
enum WeaponTypes {Melee,Ranged}
@export_enum('Melee','Ranged') var weaponType
enum ItemTypes {ActiveSkill,PassiveSkill,Consumable,Weapon}
@export_enum('ActiveSkill','PassiveSkill','Consumable','Weapon') var itemType
@export var itemName: String = 'default item'
@export var cooldown: float = 0
@export var range: float = 0
@export var damage: float = 0
@export var knockback: float = 0
@export var healthRestore: float = 0
@export var speedBoost: float = 0
@export var duration: float = 0
@export var uses: int = 0
@export var projectilePath: String

# like a door

var playerIsOnTop: bool = false

func _process(delta: float) -> void:
	if playerIsOnTop and Input.is_action_pressed("ui_accept"):
		swapItems()


func swapItems():
	var player : PlayerCharacterBase = get_tree().get_root().get_node('Main2D/Character')
	if itemType == ItemTypes.Weapon:
		player.weapon = self
		get_parent().remove_child(self)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body is PlayerCharacterBase):
		Globals.hoverItem.emit(self)
		playerIsOnTop = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if(body is PlayerCharacterBase):
		Globals.hoverItem.emit(null)
		playerIsOnTop = false
