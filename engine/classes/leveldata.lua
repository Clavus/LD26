
LevelData = class('LevelData')

function LevelData:initialize()
	
	self.level_width = 100
	self.level_height = 100
	self.level_tilewidth = 32
	self.level_tileheight = 32
	
	-- Example formats for the below tables
	self.layers = {
		--[[
		{
			name = "layername",
			opacity = 1,
			properties = {},
			tiles = {
				{ 
					tileset = { [tileset table (self.tilesets[x])] },
					draw_quad = Quad(),
					x = 0,
					y = 0
				},
				...
			}
		},
		...
		]]--
	}
	self.objects = {
		--[[
		{
			type = "Object",
			x = 320,
			y = 288,
			w = 32, -- if polygon not defined
			h = 32,
			polygon = { { x = 0, y = 0 }, { x = 16, y = 0 }, ... }, -- if w and h not defined
			properties = {}
		},
		...
		]]--
	}
	self.tilesets = {
		--[[
		{
			name = "",
			properties = {},
			image = Image(),
			imagewidth = 320,
			imagheight = 320,
			tilewidth = 32,
			tileheight = 32,
			tilemargin = 0,
			tilespacing = 0
		},
		...
		]]--
	}

end

function LevelData:getLayers()
	
	return self.layers
	
end

function LevelData:getObjects()
	
	return self.objects
	
end
