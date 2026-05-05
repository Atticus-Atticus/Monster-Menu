extends Node3D

@onready var slimetwink2 = $Slimetwink2
@onready var squashed_slimetwink = $"squashed slimetwink" 
@onready var boss = $"Boss Slime"

func _ready():
	Playerdata.trigger_boss_drop.connect(_on_boss_drop_triggered)

func _on_boss_drop_triggered():
	boss.process_mode = Node.PROCESS_MODE_INHERIT
	boss.velocity.y = -30
	
	while not boss.is_on_floor():
		await get_tree().process_frame
		
	
	slimetwink2.hide()
	slimetwink2.process_mode = Node.PROCESS_MODE_DISABLED
	
	if is_instance_valid(squashed_slimetwink):
		squashed_slimetwink.show()
		squashed_slimetwink.process_mode = Node.PROCESS_MODE_INHERIT
		
	print("SLIMETWINK CRUSHED!")
	
	await get_tree().create_timer(1.5).timeout
	boss.awake = true
