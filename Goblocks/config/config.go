package config

import "goblocks/util"

type values struct {
	Separator string
	Prefix    string
	Blocks    []util.Block
}

func Get() values {
	return values{
		Separator: " | ",
		Blocks: []util.Block{
			{
				Prefix:       "Mem: ",
				UpdateSignal: "37",
				Command:      "#Memory",
				Suffix:       "%",
				Format:       "%.2f",
				Timer:        "2s",
			},
			{
				Prefix:       "CPU: ",
				UpdateSignal: "38",
				Command:      "#Cpu",
				Suffix:       "%",
				Format:       "%.2f",
				Timer:        "2s",
			},
			{
				Prefix:       "🔊 ",
				UpdateSignal: "36",
				Command:      "amixer get Master | awk '{print $5}' | tail -1 | tr -d '[]'",
				Timer:        "0",
			},
			{
				UpdateSignal: "35",
				Prefix:       "",
				Command:      "#Date",
				Format:       "Mon 02-01-2006 3:04 PM",
				Timer:        "1s",
			},
		},
	}
}
