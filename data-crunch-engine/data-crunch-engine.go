// data-crunch-engine data-crunch-engine.go

package main

import (
	"fmt"
	"strconv"
	"time"

	log "github.com/sirupsen/logrus"

	"github.com/golang/protobuf/proto"
	"github.com/nats-io/nats.go"
)

const numberWorkers = 10
const replyWaitTime = 20 // In seconds

// Check your error
func checkErr(err error) {
	if err != nil {
		log.Fatal("ERROR:", err)
	}
}

func crunchData(dataCruncherID int, workerID int, rcvPerson *Person) string {

	fmt.Printf("---- [%v][%v] START - Crunching Data for count %v\n", dataCruncherID, workerID, rcvPerson.Count)
	time.Sleep(10 * time.Second)
	fmt.Printf("---- [%v][%v] DONE - Crunching Data for count %v\n", dataCruncherID, workerID, rcvPerson.Count)
	results := fmt.Sprintf("[%v][%v] The results are from %v", dataCruncherID, workerID, rcvPerson.Count)
	return results
}

func dataCrunchWorker(nc *nats.Conn, dataCh chan *nats.Msg, resultsCh chan string, dataCruncherID int, workerID int) {

	// Pick off channel (Only one subscriber will grab the msg off the channel. This is 1-1 communication)
	for msg := range dataCh {

		// UNMARSHAL -> DATA
		rcvPerson := &Person{}
		err := proto.Unmarshal(msg.Data, rcvPerson)
		checkErr(err)

		log.Printf("[%v][%v] Person received for count %v\n", dataCruncherID, workerID, rcvPerson.Count)

		// REPLY
		myReply := &MyReply{}
		myReply.Thereply = fmt.Sprintf("[%v][%v] Crunching data for count %d", dataCruncherID, workerID, rcvPerson.Count)

		// MARSHAL
		replymsg, err := proto.Marshal(myReply)
		checkErr(err)

		// SEND
		// NATS - PUBLISH on "data" (THE PIPE)
		log.Printf("[%v][%v] Publishing replymsg (%v) to subject 'data'\n", dataCruncherID, workerID, myReply.Thereply)
		err = nc.Publish(msg.Reply, replymsg)
		checkErr(err)

		// CRUNCH DATA & GET RESULTS
		results := crunchData(dataCruncherID, workerID, rcvPerson)

		// SEND RESULTS TO MAIN
		resultsCh <- results
	}
}

func main() {

	// CREATE UNIQUE ID BASED ON TIME
	timeStart := time.Now().UTC()
	uniqueIDstr := timeStart.Format("05")
	uniqueID, _ := strconv.Atoi(uniqueIDstr)
	fmt.Println(uniqueID)

	// CONNECT TO NATS (nats-server)
	nc, err := nats.Connect("nats://127.0.0.1:4222")
	checkErr(err)
	defer nc.Close()
	log.Println("Connected to " + nats.DefaultURL)

	// Create the Channels
	dataCh := make(chan *nats.Msg)
	resultsCh := make(chan string)

	// Create Workers
	for i := 0; i < numberWorkers; i++ {
		fmt.Printf("[%v][%v] Creating dataCrunchWorker\n", uniqueID, i)
		go dataCrunchWorker(nc, dataCh, resultsCh, uniqueID, i)
	}

	// RECEIVE
	nc.QueueSubscribe("data", "jeffsQueue", func(msg *nats.Msg) {
		dataCh <- msg
	})

	for resultsMsg := range resultsCh {

		fmt.Println("YEAH", resultsMsg)

		// DATA
		sndPerson := &Person{
			Name:  resultsMsg,
			Age:   20,
			Email: "blah@blah.com",
			Phone: "555-555-5555",
			Count: 1,
		}

		// MARSHAL
		msg, err := proto.Marshal(sndPerson)
		checkErr(err)

		// SEND
		// NATS - REQUEST & REPLY on "results" (THE PIPE)
		log.Printf("   Send request msg to subject 'results'\n")
		reply, err := nc.Request("results", msg, replyWaitTime*time.Second)
		checkErr(err)

		// UNMARSHAL -> DATA
		myReply := &MyReply{}
		err = proto.Unmarshal(reply.Data, myReply)
		checkErr(err)
		log.Printf("   Reply received: %v\n", myReply.Thereply)
	}

	// wait - empty select
	select {}

}
