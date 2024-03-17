extends TextureRect

class_name DailyEvents

# Suspicion signals
signal event_add_suspicion(amount:float)
signal event_reduce_suspicion(amount:float)

# Blood signals
signal event_add_blood(amount: float)
signal event_reduce_blood(amount: float)

# Money signals
signal event_add_money(amount: int)
signal event_reduce_money(amount: int)
signal event_change_modifier_money(days: int, modifier: float)

# Spread signals
signal event_change_modifier_spread(days: int, modifier: float)

# Church signals
signal event_spawn_church(amount: int)
signal event_despawn_church(amount: int)

@export var daily_events: Array = [{
	"name": "Family finds hidden Treasure",
	"flavourText": "John Doe, one of our city’s residents, found hidden treasure in an unlikely place. Read more on page… ",
	"positiveEffect": {
	  "suspicion": -20
	},
	"negativeEffect": {
	  "money": -25
	}
  },
  {
	"name": "Local alchemist builds a soup kitchen",
	"flavourText": "To combat the rising numbers of starving people, local alchemists build a soup kitchen. And everyone’s invited.",
	"positiveEffect": {
	  "spread": {
		"days": 3,
		"modifier": 2.5
	  }
	},
	"negativeEffect": {
	  "money": -25
	}
  },
  {
	"name": "Assassination attempt",
	"flavourText": "An assassination attempt on the leader of the alchemists was thwarted by local guards. Our hero had this to say…",
	"positiveEffect": {
	  "suspicion": -20
	},
	"negativeEffect": {
	  "blood": -15
	}
  },
  {
	"name": "Hate crime",
	"flavourText": "A faction of religious extremists violently attacked a group of alchemists in broad daylight. Justice must be served.",
	"positiveEffect": {
	  "church": -1
	},
	"negativeEffect": {
	  "blood": -15
	}
  },
  {
	"name": "Market fire",
	"flavourText": "The market caught ablaze! Accident or foul play, only time will tell.",
	"positiveEffect": {
	  "money": 30
	},
	"negativeEffect": {
	  "money": {
		"days": 3,
		"modifier": 0.25
	  }
	}
  },
  {
	"name": "Food shortage",
	"flavourText": "Food prices shot up as grain shipment got contaminated. The people look to the church for answers.",
	"positiveEffect": {
	  "church": -1
	},
	"negativeEffect": {
	  "money": {
		"days": 3,
		"modifier": 0.25
	  }
	}
  },
  {
	"name": "The sickness",
	"flavourText": "As a mystery sickness sweeps through the city. The demand for a cure is growing fast. Both the alchemists and the church answer the call.",
	"positiveEffect": {
	  "spread": {
		"days": 3,
		"modifier": 2.5
	  }
	},
	"negativeEffect": {
	  "church": 1
	}
  },
  {
	"name": "Burglar on the loose",
	"flavourText": "A series of small thefts leaves the city Befuddled! Investigation is underway.",
	"positiveEffect": {
	  "money": 30
	},
	"negativeEffect": {
	  "suspicion": 30
	}
  },
  {
	"name": "New drug strikes the slums",
	"flavourText": "A new Drug epidemic sweeps across the less fortunate. More information as the situation develops.",
	"positiveEffect": {
	  "money": {
		"days": 3,
		"modifier": 1.5
	  }
	},
	"negativeEffect": {
	  "suspicion": 30
	}
  },
  {
	"name": "Curfew",
	"flavourText": "A beast has found its way into the city, many injured and dead. The guards ask citizens to stay at home.",
	"positiveEffect": {
	  "money": {
		"days": 3,
		"modifier": 1.5
	  }
	},
	"negativeEffect": {
	  "spread": {
		"days": 3,
		"modifier": 0.25
	  }
	}
  },
  {
	"name": "Disappearance at The carnival",
	"flavourText": "The Carnival is in town again. Number of attendees at an all time high. Among the celebrations people went missing.",
	"positiveEffect": {
	  "blood": 25
	},
	"negativeEffect": {
	  "spread": {
		"days": 3,
		"modifier": 0.25
	  }
	}
  }]

var was_shown = false

static var is_shown = false

func _input(event):
	if visible and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			visible = false;

func _process(_delta):
	if !TimeCycle.is_day and !was_shown:
		onPublish()
	elif TimeCycle.is_day:
		was_shown = false
	is_shown = visible

func onPublish():
	if daily_events:
		var daily_event = daily_events.pick_random()
		$TitleLabel.set_text(daily_event.name)
		$SubTitleLabel.set_text(daily_event.flavourText)
		visible = true
		was_shown = true
		startEffect(daily_event.positiveEffect)
		startEffect(daily_event.negativeEffect)

func startEffect(effect: Dictionary):
	if effect.has("suspicion"):
		if effect.suspicion is int or effect.suspicion is float:
			if effect.suspicion > 0:
				emit_signal("event_add_suspicion", effect.suspicion)
			elif effect.suspicion < 0:
				emit_signal("event_reduce_suspicion", effect.suspicion)
	elif effect.has("blood"):
		if effect.blood is int or effect.blood is float:
			if effect.blood > 0:
				emit_signal("event_add_blood", effect.blood)
			elif effect.blood < 0:
				emit_signal("event_reduce_blood", effect.blood)
	elif effect.has("money"):
		if effect.money is int or effect.money is float:
			if effect.money > 0:
				emit_signal("event_add_money", int(effect.money))
			elif effect.money < 0:
				emit_signal("event_reduce_money", int(effect.money))
		elif effect.money.days and effect.money.modifier:
			emit_signal("event_change_modifier_money", effect.money.days, effect.money.modifier)
	elif effect.has("spread"):
		emit_signal("event_change_modifier_spread", effect.spread.days, effect.spread.modifier)
	elif effect.has("church"):
		if effect.church > 0:
			emit_signal("event_spawn_church", effect.church)
		elif effect.church < 0:
			emit_signal("event_despawn_church", effect.church)
