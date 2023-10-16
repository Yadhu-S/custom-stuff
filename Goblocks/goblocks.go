package main

import (
	"goblocks/config"
	"goblocks/util"
	"log"
	"os"
	"runtime"
	"strings"

	"github.com/BurntSushi/xgb"
	"github.com/BurntSushi/xgb/xproto"
)

var (
	// displayBlocks contains text of all blocks
	displayBlocks []string
	channels      []chan bool
	signalMap     map[string]int = make(map[string]int)
)

func main() {
	// establish connection to X server
	x, err := xgb.NewConn()
	if err != nil {
		log.Fatal(err)
	}
	runtime.GOMAXPROCS(1)
	defer x.Close()
	root := xproto.Setup(x).DefaultScreen(x).Root
	config := config.Get()
	channels = make([]chan bool, len(config.Blocks))
	//dataChannel is common for gothreads contributing to status bar
	dataChannel := make(chan util.Change)
	for i, block := range config.Blocks {
		//Assign a cell for each separator/prefix/action/suffix
		if config.Separator != "" {
			displayBlocks = append(displayBlocks, config.Separator)
		}

		displayBlocks = append(displayBlocks, block.Prefix)

		// data will be replaced on this idx
		displayBlocks = append(displayBlocks, "W")
		actionId := len(displayBlocks) - 1

		displayBlocks = append(displayBlocks, block.Suffix)

		//Create an unique channel for each action
		channels[i] = make(chan bool)
		signalMap["signal "+block.UpdateSignal] = i

		if _, isBuiltin := util.PreBuiltFunctionMap[block.Command]; isBuiltin {
			go util.PreBuiltFunctionMap[block.Command](actionId, dataChannel, channels[i], block)
		} else {
			go util.RunCmd(actionId, dataChannel, channels[i], block)
		}

		timer := block.Timer
		if timer != "0" {
			go util.Schedule(channels[i], timer)
		}
	}
	go handleSignals(util.GetSIGRTchannel())
	//start event loop
	for {
		//Block until some gothread has an update
		res := <-dataChannel
		displayBlocks[res.BlockId] = res.Data
		updateBar(x, root)
	}
}

//Goroutine that pings a channel according to received signal
func handleSignals(rec chan os.Signal) {
	for {
		sig := <-rec
		if index, ok := signalMap[sig.String()]; ok {
			channels[index] <- true
		}
	}
}

//Craft status text out of blocks data
func updateBar(conn *xgb.Conn, rootWindow xproto.Window) {
	var builder strings.Builder
	for _, s := range displayBlocks {
		builder.WriteString(s)
	}
	xproto.ChangeProperty(conn, xproto.PropModeReplace, rootWindow, xproto.AtomWmName, xproto.AtomString, 8, uint32(builder.Len()), []byte(builder.String()))
}
