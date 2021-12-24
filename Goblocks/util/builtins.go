package util

import (
	"fmt"
	"time"

	"github.com/shirou/gopsutil/cpu"
	"github.com/shirou/gopsutil/mem"
)

//blockId is automatically allocated
//send channel is used to update blocks data
//Gothreads are waked up by messages on rec channels
//action is a map of whatever was in action json object for corressponding action
var PreBuiltFunctionMap = map[string]func(blockId int, send chan Change, rec chan bool, action Block){
	"#Date":   Date,
	"#Memory": Memory,
	"#Cpu":    Cpu,
}

//Update time according to "format" property
func Date(blockId int, send chan Change, rec chan bool, action Block) {
	run := true
	for run {
		send <- Change{blockId, time.Now().Format(action.Format), true}
		//Block until other thread will ping you
		run = <-rec
	}
}

//Get current % of used memory
func Memory(blockId int, send chan Change, rec chan bool, action Block) {
	run := true
	for run {
		v, _ := mem.VirtualMemory()
		send <- Change{blockId, fmt.Sprintf(action.Format, v.UsedPercent), true}
		//Block until other thread will ping you
		run = <-rec
	}
}

//Get current % of used CPU
func Cpu(blockId int, send chan Change, rec chan bool, action Block) {
	run := true
	for run {
		val, _ := cpu.Percent(time.Second, false)
		send <- Change{blockId, fmt.Sprintf(action.Format, val[0]), true}
		//Block until other thread will ping you
		run = <-rec
	}
}
