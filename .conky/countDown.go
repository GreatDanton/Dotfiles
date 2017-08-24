package main

// see this thread for more ideas:
// https://www.reddit.com/r/golang/comments/5aqc6c/reassigning_variables_code_review/
import (
	"fmt"
	"os"
	"time"
)

// reading final date from countdown file and calculating the amount
// of days, hours, minutes, seconds between now and chosen final date
func main() {
	// data is imported via arguments
	data := fmt.Sprint(os.Args[1])

	// get location, so the time is parsed correctly according to the location
	loc, err := time.LoadLocation("Local")
	if err != nil {
		fmt.Println(err)
		return
	}

	// parse time in desired format (days.months.years)
	t, err := time.ParseInLocation("2.1.2006", data, loc)
	if err != nil {
		fmt.Println(err)
		return
	}

	days, hours, minutes, seconds := timeDiff(t)

	fmt.Println("Days  Hours  Minutes  Seconds")
	fmt.Printf("%4v %5v %6v %8v", days, hours, minutes, seconds)
}

// calculating time difference between desired time and now
func timeDiff(t time.Time) (days, hours, minutes, seconds string) {
	diff := t.Unix() - time.Now().Unix()

	d := diff / 86400
	diff = diff - (d * 86400)

	h := (diff / 3600)
	diff = diff - h*3600

	m := diff / 60
	diff = diff - m*60

	s := diff

	// returning values
	days = fmt.Sprintf("%v", d)
	hours = prefixNumber(h)
	minutes = prefixNumber(m)
	seconds = prefixNumber(s)

	return
}

// Prefixes a number with 0 if necessary
func prefixNumber(number int64) string {
	returnVal := ""
	if number < 10 && number > 0 {
		returnVal = fmt.Sprintf("0%v", number)
	} else {
		returnVal = fmt.Sprintf("%v", number)
	}
	return returnVal
}
