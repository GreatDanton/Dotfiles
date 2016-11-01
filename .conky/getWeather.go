package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"sort"
	"strconv"
	"time"
)

const URL = "http://api.openweathermap.org/data/2.5/forecast/daily?q=Ljubljana,us&mode=json&units=metric&appid=322fb42145c8a682b9abc1d2c1f8f41c&cnt=4"

type Weather struct {
	Cnt      int             `json:"cnt"`
	Forecast []*DailyWeather `json:"list"`
}

type DailyWeather struct {
	UnixTime    int `json:"dt"`
	Temp        *Temp
	Description []*Description `json:"weather"`
}
type Temp struct {
	Min float64 `json:"min"`
	Max float64 `json:"max"`
}

type Description struct {
	Desc string `json:"description"`
}

// parse data from url
func parseData(url string) *Weather {
	response, err := http.Get(URL)

	if err != nil {
		fmt.Errorf("Weather parse failed %s", err)
	}

	if response.StatusCode != http.StatusOK {
		response.Body.Close()
		fmt.Errorf("%s", response.Status)
	}

	var parsedData Weather
	if err := json.NewDecoder(response.Body).Decode(&parsedData); err != nil {
		fmt.Errorf("%s", err)
		response.Body.Close()
	}
	response.Body.Close()
	return &parsedData
}

func buildDict(data *Weather) map[int]map[string]string {
	forecast := make(map[int]map[string]string)

	for _, day := range data.Forecast {
		stats := make(map[string]string)

		min := strconv.FormatFloat(day.Temp.Min, 'f', 1, 64)
		max := strconv.FormatFloat(day.Temp.Max, 'f', 1, 64)

		stats["Min"] = min
		stats["Max"] = max
		stats["Description"] = day.Description[0].Desc

		forecast[day.UnixTime] = stats
		/*
			// GETTING VALUES
				fmt.Printf("Unix Time: %d\n", day.UnixTime)
				fmt.Printf("Temp Min: %f\n", day.Temp.Min)
				fmt.Printf("Temp Max: %f\n", day.Temp.Max)
				fmt.Printf("Description: %s\n", day.Description[0].Desc)
		*/
	}
	return forecast
}

func main() {
	data := parseData(URL)

	forecast := buildDict(data)

	var days []int
	for key, _ := range forecast {
		days = append(days, key)
	}
	// sort numbers ascending
	sort.Ints(days)

	for counter, day := range days {
		// day(name), Min, Max, Description

		var name string

		if counter == 0 {
			name = "Today"
		} else {
			tm := time.Unix(int64(day), 0).Weekday()
			name = tm.String()
		}

		min := forecast[day]["Min"]
		max := forecast[day]["Max"]
		desc := forecast[day]["Description"]

		fmt.Printf("%-9s   Min: %5s°C    Max: %5s°C    %s\n", name, min, max, desc)
	}

}
