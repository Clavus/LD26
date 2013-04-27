
CHARACTER_FRAME_SIZE = 64

SPRITELAYOUT = {}
SPRITELAYOUT["character"] = {
	{ state_name = "movedown", num_columns = 4, num_frames = 4, offset = Vector(0,0), fps = 12, loops = true },
	{ state_name = "moveright", num_columns = 4, num_frames = 4, offset = Vector(0,CHARACTER_FRAME_SIZE), fps = 12, loops = true },
	{ state_name = "moveleft", num_columns = 4, num_frames = 4, offset = Vector(0,CHARACTER_FRAME_SIZE*2), fps = 12, loops = true },
	{ state_name = "moveup", num_columns = 4, num_frames = 4, offset = Vector(0,CHARACTER_FRAME_SIZE*3), fps = 12, loops = true },
	{ state_name = "attackdown", num_columns = 4, num_frames = 4, offset = Vector(CHARACTER_FRAME_SIZE,0), fps = 12, loops = true },
	{ state_name = "attackright", num_columns = 4, num_frames = 4, offset = Vector(CHARACTER_FRAME_SIZE,CHARACTER_FRAME_SIZE), fps = 12, loops = true },
	{ state_name = "attackleft", num_columns = 4, num_frames = 4, offset = Vector(CHARACTER_FRAME_SIZE,CHARACTER_FRAME_SIZE*2), fps = 12, loops = true },
	{ state_name = "attackup", num_columns = 4, num_frames = 4, offset = Vector(CHARACTER_FRAME_SIZE,CHARACTER_FRAME_SIZE*3), fps = 12, loops = true }
}