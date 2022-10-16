extends RichTextLabel

func _ready():
	Global.title = self

func update_title(title):
	text = "[center]%s[/center]" % title
	get_node("SongShadow").text = "[center]%s[/center]" % title
