extends SubViewportContainer

func _ready():
	#TODO make viewport size auto following tile get area
	await RenderingServer.frame_post_draw
	$SubViewport.get_texture().get_image().save_png("user://map.png")
