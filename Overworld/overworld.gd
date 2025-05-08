extends SubViewport

func _ready():
	await RenderingServer.frame_post_draw
	$".".get_texture().get_image().save_png("user://Screenshot.png")
