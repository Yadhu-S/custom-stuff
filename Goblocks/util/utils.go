package util

import (
	"log"
	"os"
	"os/exec"
	"os/signal"
	"strings"
	"syscall"
	"time"
)

type Change struct {
	BlockId int
	Data    string
	Success bool
}

type Block struct {
	Prefix       string
	UpdateSignal string
	Command      string
	Suffix       string
	Format       string
	Timer        string
}

//Based on "timer" prorty from config file
//Schedule gothread that will ping other gothreads via send channel
func Schedule(send chan bool, duration string) {
	u, err := time.ParseDuration(duration)
	if err != nil {
		log.Println("Couldn't set a scheduler due to improper time format: " + duration)
		send <- false
	}
	for range time.Tick(u) {
		send <- true
	}
}

//Run any arbitrary POSIX shell command
func RunCmd(blockId int, send chan Change, rec chan bool, act Block) {
	cmdStr := act.Command
	run := true

	for run {
		out, err := exec.Command("sh", "-c", cmdStr).Output()
		if err != nil {
			log.Printf("%s failed", cmdStr)
			//send <- Change{blockId, err.Error(), false}
			return
		}
		send <- Change{blockId, strings.TrimSuffix(string(out), "\n"), true}
		//Block until other thread will ping you
		run = <-rec
	}
}

//Create a channel that captures all 34-64 signals
func GetSIGRTchannel() chan os.Signal {
	sigChan := make(chan os.Signal, 1)
	sigArr := make([]os.Signal, 31)
	for i := range sigArr {
		sigArr[i] = syscall.Signal(i + 0x22)
	}
	signal.Notify(sigChan, sigArr...)
	return sigChan
}
