
CHARACTER_FRAME_SIZE = 64
ATTACKEFF_FRAME_SIZE = 64
BUBBLE_FRAME_SIZE = 128

SPRITELAYOUT = {}
SPRITELAYOUT["character"] = {
	{ state_name = "movedown", num_columns = 4, num_frames = 4, offset = Vector(0,0), fps = 12, loops = true },
	{ state_name = "moveright", num_columns = 4, num_frames = 4, offset = Vector(0,CHARACTER_FRAME_SIZE), fps = 12, loops = true },
	{ state_name = "moveleft", num_columns = 4, num_frames = 4, offset = Vector(0,CHARACTER_FRAME_SIZE*2), fps = 12, loops = true },
	{ state_name = "moveup", num_columns = 4, num_frames = 4, offset = Vector(0,CHARACTER_FRAME_SIZE*3), fps = 12, loops = true },
	{ state_name = "attackdown", num_columns = 4, num_frames = 4, offset = Vector(CHARACTER_FRAME_SIZE*4,0), fps = 24, loops = false },
	{ state_name = "attackright", num_columns = 4, num_frames = 4, offset = Vector(CHARACTER_FRAME_SIZE*4,CHARACTER_FRAME_SIZE), fps = 24, loops = false },
	{ state_name = "attackleft", num_columns = 4, num_frames = 4, offset = Vector(CHARACTER_FRAME_SIZE*4,CHARACTER_FRAME_SIZE*2), fps = 24, loops = false },
	{ state_name = "attackup", num_columns = 4, num_frames = 4, offset = Vector(CHARACTER_FRAME_SIZE*4,CHARACTER_FRAME_SIZE*3), fps = 24, loops = false },
	{ state_name = "death", num_columns = 4, num_frames = 4, offset = Vector(CHARACTER_FRAME_SIZE*8,0), fps = 12, loops = false }
}

SPRITELAYOUT["zombie"] = {
	{ state_name = "movedown", num_columns = 4, num_frames = 4, offset = Vector(0,0), fps = 6, loops = true },
	{ state_name = "moveright", num_columns = 4, num_frames = 4, offset = Vector(0,CHARACTER_FRAME_SIZE), fps = 6, loops = true },
	{ state_name = "moveleft", num_columns = 4, num_frames = 4, offset = Vector(0,CHARACTER_FRAME_SIZE*2), fps = 6, loops = true },
	{ state_name = "moveup", num_columns = 4, num_frames = 4, offset = Vector(0,CHARACTER_FRAME_SIZE*3), fps = 6, loops = true },
	{ state_name = "death", num_columns = 4, num_frames = 4, offset = Vector(CHARACTER_FRAME_SIZE*4,0), fps = 12, loops = false }
}

SPRITELAYOUT["effect_attack"] = {
	{ state_name = "down", num_columns = 4, num_frames = 4, offset = Vector(0,0), fps = 24, loops = false },
	{ state_name = "right", num_columns = 4, num_frames = 4, offset = Vector(0,ATTACKEFF_FRAME_SIZE), fps = 24, loops = false },
	{ state_name = "left", num_columns = 4, num_frames = 4, offset = Vector(0,ATTACKEFF_FRAME_SIZE*2), fps = 24, loops = false },
	{ state_name = "up", num_columns = 4, num_frames = 4, offset = Vector(0,ATTACKEFF_FRAME_SIZE*3), fps = 24, loops = false }
}

SPRITELAYOUT["speechbubble"] = {
	{ state_name = "restart", num_columns = 1, num_frames = 1, offset = Vector(0,0), fps = 0, loops = false },
	{ state_name = "arrowkeys", num_columns = 1, num_frames = 1, offset = Vector(0,BUBBLE_FRAME_SIZE), fps = 0, loops = false },
	{ state_name = "spacebar", num_columns = 1, num_frames = 1, offset = Vector(BUBBLE_FRAME_SIZE, 0), fps = 0, loops = false },
	{ state_name = "daughter", num_columns = 1, num_frames = 1, offset = Vector(BUBBLE_FRAME_SIZE,BUBBLE_FRAME_SIZE), fps = 0, loops = false },
	{ state_name = "kitty", num_columns = 1, num_frames = 1, offset = Vector(BUBBLE_FRAME_SIZE*2, 0), fps = 0, loops = false },
	{ state_name = "help", num_columns = 1, num_frames = 1, offset = Vector(BUBBLE_FRAME_SIZE*2,BUBBLE_FRAME_SIZE), fps = 0, loops = false },
	{ state_name = "hero", num_columns = 1, num_frames = 1, offset = Vector(BUBBLE_FRAME_SIZE*3,0), fps = 0, loops = false },
	{ state_name = "thanks", num_columns = 1, num_frames = 1, offset = Vector(BUBBLE_FRAME_SIZE*3,BUBBLE_FRAME_SIZE), fps = 0, loops = false },
	{ state_name = "deliver", num_columns = 1, num_frames = 1, offset = Vector(BUBBLE_FRAME_SIZE,BUBBLE_FRAME_SIZE*3), fps = 0, loops = false },
	{ state_name = "obstacle", num_columns = 1, num_frames = 1, offset = Vector(BUBBLE_FRAME_SIZE*2,BUBBLE_FRAME_SIZE*3), fps = 0, loops = false }
}