class_name SaveData extends Resource

@export var highscore: int = 0

const SAVE_PATH:String = "user://alienattackhighscore1_1.tres"

func save() -> void:
	ResourceSaver.save(self, SAVE_PATH)

static func load_or_create() -> SaveData:
	var res
	if FileAccess.file_exists(SAVE_PATH):
		res = load(SAVE_PATH) as SaveData
	else:
		res = SaveData.new()
	return res
