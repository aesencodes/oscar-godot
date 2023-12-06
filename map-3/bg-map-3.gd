extends ParallaxBackground


var scrolling_speed = 100

func _proccess(delta):
	scroll_offset.x -= scrolling_speed * delta
