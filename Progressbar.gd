extends TextureProgressBar

func _ready():
	Global.progressbar = self

func SetProgress(percent):
	value = percent * max_value
