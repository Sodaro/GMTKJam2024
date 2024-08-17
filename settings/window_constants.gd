extends Resource

class_name WindowConstants

var resolution_options:Dictionary = {
	"320x240": Vector2i(320, 240),
	"640x480": Vector2i(640, 480),
	"960x720": Vector2i(960,720),
	"1600x1200": Vector2i(1600,1200),
	"1920x1440": Vector2i(1920, 1440)
}

var display_mode_options:Dictionary = {
	"Windowed" : Window.MODE_WINDOWED,
	"Borderless Fullscreen" : Window.MODE_FULLSCREEN,
	"Fullscreen" : Window.MODE_EXCLUSIVE_FULLSCREEN,
}
