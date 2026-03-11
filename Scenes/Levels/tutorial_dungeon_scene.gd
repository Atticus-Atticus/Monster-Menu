extends Node3D

@onready var slimetwink2 = $Slimetwink2 # Your alive NPC
@onready var squashed_slimetwink = $"squashed slimetwink" # Your hidden harvestable NPC
@onready var boss = $"Boss Slime" # Your boss in the sky

func _ready():
	# Listen for the dialogue trigger
	Playerdata.trigger_boss_drop.connect(_on_boss_drop_triggered)

func _on_boss_drop_triggered():
	# 1. Turn the boss on so gravity takes over!
	boss.process_mode = Node.PROCESS_MODE_INHERIT
	
	# 2. Force the boss downwards incredibly fast
	boss.velocity.y = -30 
	
	# 3. Wait until the boss hits the floor
	while not boss.is_on_floor():
		await get_tree().process_frame
		
	# --- IMPACT HAPPENS HERE ---
	
	# 4. Hide/Disable the original NPC
	slimetwink2.hide()
	slimetwink2.process_mode = Node.PROCESS_MODE_DISABLED
	
	# 5. Show the squashed NPC (but don't make it harvestable yet!)
	squashed_slimetwink.show()
	
	# Optional: Add camera shake or a loud BANG sound effect here!
	print("SLIMETWINK CRUSHED!")
	
	# 6. Wake the boss up to fight the player
	boss.awake = true
