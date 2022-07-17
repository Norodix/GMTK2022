extends CanvasLayer

onready var icon_jump    = preload("Hud_Jump.png")
onready var icon_dash    = preload("Hud_Dash.png")
onready var icon_explode = preload("Hud_Explosion.png")
onready var icon_random  = preload("Hud_Random.png")

onready var icons : Dictionary = {
	"jump" 		: icon_jump,
	"dash" 		: icon_dash,
	"explode" 	: icon_explode,
	"random" 	: icon_random,
}

var colors : Dictionary = {
	"jump" 		: Color("#4040ff"),
	"dash" 		: Color("#55ff55"),
	"explode" 	: Color("#ffd955"),
	"random" 	: Color("#ff5555"),
}

func _ready():
	pass # Replace with function body.

func set_ability(ability : Ability):
	if not ability:
		$Indicator.visible = false
		return
	$Indicator.visible = true
	var icon = icons[ability.callback]
	$Indicator.texture = icon
	$Indicator.modulate = colors[ability.callback]
	pass


