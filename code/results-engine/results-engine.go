// data-crunch-engine results-engine.go

package main

import (
	"fmt"
	"time"

	log "github.com/sirupsen/logrus"

	"github.com/golang/protobuf/proto"
	"github.com/nats-io/nats.go"
)

// Check your error
func checkErr(err error) {
	if err != nil {
		log.Fatal("ERROR:", err)
	}
}

func main() {

	// CREATE UNIQUE ID BASED ON TIME
	timeStart := time.Now().UTC()
	uniqueID := timeStart.Format("05")
	fmt.Println(uniqueID)

	// CONNECT TO NATS (nats-server)
	nc, err := nats.Connect("nats://127.0.0.1:4222")
	checkErr(err)
	defer nc.Close()
	log.Println("Connected to " + nats.DefaultURL)

	// SUBSCRIBE TO "results"
	nc.Subscribe("results", func(msg *nats.Msg) {

		// UNMARSHAL -> DATA
		rcvPerson := &Person{}
		err = proto.Unmarshal(msg.Data, rcvPerson)
		checkErr(err)

		log.Printf("Person received: %+v\n", rcvPerson)

		// REPLY
		myReply := &MyReply{}
		myReply.Thereply = fmt.Sprintf("This is a response %v, from count %d", uniqueID, rcvPerson.Count)

		// MARSHAL
		replymsg, err := proto.Marshal(myReply)
		checkErr(err)

		// SEND
		// NATS - PUBLISH on "results" (THE PIPE)
		log.Printf("- Publishing replymsg (%v) to subject 'results'\n", myReply.Thereply)
		err = nc.Publish(msg.Reply, replymsg)
		checkErr(err)

	})

	// wait - empty select
	select {}

}
