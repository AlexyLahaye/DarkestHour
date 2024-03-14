extends Control

@onready var player = GameState.player

func _ready():
	$HealthBar.max_value = player.max_health
	$HealthBar.value = player.health
	$ManaBar.value = 100
	$ExpBar.value = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HealthBar.value = player.health
	if player.first_skill_enable == false:
		print(player.first_skill_cd)
		$FirstSkillD/LabelFSD.text = player.first_skill_cd
		$FirstSkillD.visible = true
	else:
		$FirstSkillD.visible = false
	if player.second_skill_enable == false:
		print(player.first_skill_cd)
		$SecondSkillD/LabelSSD.text = player.second_skill_cd
		$SecondSkillD.visible = true
	else:
		$SecondSkillD.visible = false
	if player.basic_skill_enable == false:
		print(player.first_skill_cd)
		$BasicSkillD/LabelBSD.text = player.basic_skill_cd
		$BasicSkillD.visible = true
	else:
		$BasicSkillD.visible = false
