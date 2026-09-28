extends SubViewportContainer

func _ready():
	await RenderingServer.frame_post_draw
	$SubViewport.get_texture().get_image().save_png("user://map.png")
