
CHARACTER_FRAME_SIZE = 64

SPRITELAYOUT = {}
SPRITELAYOUT["character"] = {
	{ state_name = "movedown", num_columns = 4, num_frames = 4, offset = Vector(0,0), fps = 12, loops = true },
	{ state_name = "moveright", num_columns = 4, num_frames = 4, offset = Vector(0,CHARACTER_FRAME_SIZE), fps = 12, loops = true },
	{ state_name = "moveleft", num_columns = 4, num_frames = 4, offset = Vector(0,CHARACTER_FRAME_SIZE*2), fps = 12, loops = true },
	{ state_name = "moveup", num_columns = 4, num_frames = 4, offset = Vector(0,CHARACTER_FRAME_SIZE*3), fps = 12, loops = true },
	{ state_name = "attackdown", num_columns = 4, num_frames = 4, offset = Vector(CHARACTER_FRAME_SIZE*4,0), fps = 24, loops = false },
	{ state_name = "attackright", num_columns = 4, num_frames = 4, offset = Vector(CHARACTER_FRAME_SIZE*4,CHARACTER_FRAME_SIZE), fps = 24, loops = false },
	{ state_name = "attackleft", num_columns = 4, num_frames = 4, offset = Vector(CHARACTER_FRAME_SIZE*4,CHARACTER_FRAME_SIZE*2), fps = 24, loops = false },
	{ state_name = "attackup", num_columns = 4, num_frames = 4, offset = Vector(CHARACTER_FRAME_SIZE*4,CHARACTER_FRAME_SIZE*3), fps = 24, loops = false }
}

SPRITELAYOUT["zombie"] = {
	{ state_name = "movedown", num_columns = 4, num_frames = 4, offset = Vector(0,0), fps = 6, loops = true },
	{ state_name = "moveright", num_columns = 4, num_frames = 4, offset = Vector(0,CHARACTER_FRAME_SIZE), fps = 6, loops = true },
	{ state_name = "moveleft", num_columns = 4, num_frames = 4, offset = Vector(0,CHARACTER_FRAME_SIZE*2), fps = 6, loops = true },
	{ state_name = "moveup", num_columns = 4, num_frames = 4, offset = Vector(0,CHARACTER_FRAME_SIZE*3), fps = 6, loops = true }
}

SPRITELAYOUT["effect_attack"] = {
	{ state_name = "down", num_columns = 4, num_frames = 4, offset = Vector(0,0), fps = 24, loops = false },
	{ state_name = "right", num_columns = 4, num_frames = 4, offset = Vector(0,CHARACTER_FRAME_SIZE), fps = 24, loops = false },
	{ state_name = "left", num_columns = 4, num_frames = 4, offset = Vector(0,CHARACTER_FRAME_SIZE*2), fps = 24, loops = false },
	{ state_name = "up", num_columns = 4, num_frames = 4, offset = Vector(0,CHARACTER_FRAME_SIZE*3), fps = 24, loops = false }
}