
FSM = {}

FSM["zombie"] = {
	states = { "idle", "walk", "attack", "dead" },
	events = { "see player", "killed", "time passed", "lost player" },
	links = {
		["idle"] = { ["see player"] = "attack", ["killed"] = "dead", ["time passed"] = "walk" },
		["walk"] = { ["see player"] = "attack", ["killed"] = "dead", ["time passed"] = "idle" },
		["attack"] = { ["killed"] = "dead", ["lost player"] = "idle" }
	}
}
