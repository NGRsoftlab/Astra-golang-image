package main

import (
	"archive/zip"
	"bufio"
	"bytes"
	"compress/gzip"
	"context"
	"crypto/aes"
	"encoding/json"
	"fmt"
	"image"
	"io"
	"log"
	"net"
	"net/http"
	"os"
	"regexp"
	"runtime"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

// ANSI color codes
const (
	reset  = "\033[0m"
	green  = "\033[1;32m"
	cyan   = "\033[1;36m"
	yellow = "\033[1;33m"
	red    = "\033[1;31m"
	blue   = "\033[1;34m"
)

// App version
var AppVersion = "dev-build"

// ASCII reset color
var ansiEscape = regexp.MustCompile(`\x1b$$[0-9;]*m`)

// Colored ASCII art with animation
var gopherFrames = []string{
	`
 ____                   __
/\  _'\                /\ \
\ \ \L\_\   ___   _____\ \ \___      __  _ __  ____
 \ \ \L_L  / __'\/\ '__'\ \  _ '\  /'__'/\''__/',__\
  \ \ \/, /\ \L\ \ \ \L\ \ \ \ \ \/\  __\ \ \/\__, '\
   \ \____\ \____/\ \ ,__/\ \_\ \_\ \____\ \_\/\____/
    \/___/ \/___/  \ \ \/  \/_/\/_/\/____/\/_/\/___/
                    \ \_\
                     \/_/
`,
	`
 ____          ___
/\  _'\       /\_ \
\ \ \L\_\   __\//\ \      __      ___      __
 \ \ \L_L  / __'\ \ \   /'__'\  /' _ '\  /'_ '\
  \ \ \/, /\ \L\ \_\ \_/\ \L\.\_/\ \/\ \/\ \L\ \
   \ \____\ \____/\____\ \__/.\_\ \____\ \____ \
    \/___/ \/___/\/____/\/__/\/_/\/_/\/_/\/___L\ \
                                           /\____/
                                           \_/__/
`,
	`
 ____                                               __
/\  _'\                                            /\ \
\ \ \L\_\   ___        __     ___        __     ___\ \ \
 \ \ \L_L  / __'     /'_ '\  / __'     /'_ '\  / __'\ \ \
  \ \ \/, /\ \L\    /\ \L\ \/\ \L\    /\ \L\ \/\ \L\ \ \_\
   \ \____\ \____/  \ \____ \ \____/  \ \____ \ \____/\/\_\
    \/___/ \/___/    \/___L\ \/___/    \/___L\ \/___/  \/_/
                       /\____/           /\____/
                       \_/__/            \_/__/
`,
}

var (
	httpRequestsTotal = prometheus.NewCounterVec(
		prometheus.CounterOpts{
			Name: "upx_server_requests_total",
			Help: "Total number of HTTP requests.",
		},
		[]string{"handler", "method"},
	)

	httpRequestLatency = prometheus.NewHistogramVec(
		prometheus.HistogramOpts{
			Name:    "upx_server_request_latency_seconds",
			Help:    "Latency of HTTP requests in seconds.",
			Buckets: prometheus.DefBuckets,
		},
		[]string{"handler"},
	)

	internetStatus = prometheus.NewGauge(prometheus.GaugeOpts{
		Name: "upx_server_internet_status",
		Help: "Whether the server has internet access (1 = yes, 0 = no)",
	})

	geoCacheLastUpdated = prometheus.NewGauge(prometheus.GaugeOpts{
		Name: "upx_server_geo_cache_last_updated",
		Help: "Unix timestamp of the last geo cache update",
	})

	publicIPReachable = prometheus.NewGauge(prometheus.GaugeOpts{
		Name: "upx_server_public_ip_reachable",
		Help: "Whether the public IP can be fetched (1 = yes, 0 = no)",
	})

	upxServerUp = prometheus.NewGauge(prometheus.GaugeOpts{
		Name: "upx_server_up",
		Help: "Whether the server is up and responding (1 = yes, 0 = no)",
	})
)

type Response struct {
	Message string `json:"message"`
	Time    string `json:"time"`
}

type GeoIP struct {
	Query    string  `json:"query"`
	Country  string  `json:"country"`
	Region   string  `json:"regionName"`
	City     string  `json:"city"`
	Zip      string  `json:"zip"`
	Lat      float64 `json:"lat"`
	Lon      float64 `json:"lon"`
	Timezone string  `json:"timezone"`
	Org      string  `json:"org"`
}

type Server struct {
	startTime  time.Time
	frameIndex int
	geoCache   struct {
		sync.Mutex
		ip      string
		geo     *GeoIP
		expires time.Time
	}
}

type HealthResponse struct {
	Status       string `json:"status"`
	Error        string `json:"error,omitempty"`
	PublicIP     string `json:"public_ip,omitempty"`
	GeoAvailable bool   `json:"geo_data_available,omitempty"`
	HasInternet  bool   `json:"internet_access,omitempty"`
}

func init() {
	prometheus.MustRegister(upxServerUp)
	prometheus.MustRegister(httpRequestsTotal)
	prometheus.MustRegister(httpRequestLatency)
	prometheus.MustRegister(internetStatus)
	prometheus.MustRegister(geoCacheLastUpdated)
	prometheus.MustRegister(publicIPReachable)
}

func useJSONFromRequest(r *http.Request) bool {
	return r.Header.Get("Accept") == "application/json" || r.URL.Query().Get("format") == "json"
}

func sendHealthError(w http.ResponseWriter, errorMsg string, useJSON bool) {
	if useJSON {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{
			"status": "error",
			"error":  errorMsg,
		})
	} else {
		http.Error(w, errorMsg, http.StatusInternalServerError)
	}
}

func sendHealthOK(w http.ResponseWriter, useJSON bool) {
	if useJSON {
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(map[string]string{"status": "ok"})
	} else {
		w.Header().Set("Content-Type", "text/plain")
		fmt.Fprint(w, "OK\n")
	}
}

func sendHealthResponse(w http.ResponseWriter, resp HealthResponse, useJSON bool, code int) {
	if code == 0 {
		code = http.StatusOK
	}

	if useJSON {
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(resp)
	} else {
		if code >= 400 {
			http.Error(w, resp.Error, code)
		} else {
			w.Header().Set("Content-Type", "text/plain")
			fmt.Fprint(w, "OK\n")
		}
	}
}

func visibleLength(s string) int {
	return len(ansiEscape.ReplaceAllString(s, ""))
}

func centerText(text string, width int) string {
	padding := (width - visibleLength(text)) / 2
	if padding < 0 {
		padding = 0
	}
	return strings.Repeat(" ", padding) + text
}

func alignRight(text string, offset int) string {
	if offset < 0 {
		offset = 0
	}
	return strings.Repeat(" ", offset) + text
}

func hasInternetAccess() bool {
	conn, err := net.DialTimeout("tcp", "8.8.8.8:53", 2*time.Second)
	if err != nil {
		internetStatus.Set(0)
		return false
	}
	_ = conn.Close()
	internetStatus.Set(1)
	return true
}

func getPublicIP() (string, error) {
	urls := []string{
		"https://api.ipify.org",
		"https://ifconfig.me/ip",
		"https://ident.me",
		"https://checkip.amazonaws.com",
	}

	client := &http.Client{Timeout: 5 * time.Second}
	results := make(chan string, len(urls))

	for _, url := range urls {
		go func(url string) {
			req, _ := http.NewRequest("GET", url, nil)
			req.Header.Set("User-Agent", "Go-UpX-Demo/1.0")

			resp, err := client.Do(req)
			if err != nil {
				return
			}
			defer resp.Body.Close()

			body, err := io.ReadAll(resp.Body)
			if err != nil {
				return
			}

			ip := strings.TrimSpace(string(body))
			if net.ParseIP(ip) != nil {
				results <- ip
			}
		}(url)
	}

	select {
	case ip := <-results:
		publicIPReachable.Set(1)
		return ip, nil
	case <-time.After(5 * time.Second):
		publicIPReachable.Set(0)
		return "", fmt.Errorf("failed to fetch public IP from all sources")
	}
}

func (s *Server) getCachedGeo(ip string) (*GeoIP, error) {
	s.geoCache.Lock()
	defer s.geoCache.Unlock()

	if s.geoCache.expires.After(time.Now()) && s.geoCache.ip == ip {
		return s.geoCache.geo, nil
	}

	// Update cache
	geo, err := getGeoIP(ip)
	if err != nil {
		return nil, err
	}

	s.geoCache.ip = ip
	s.geoCache.geo = geo
	s.geoCache.expires = time.Now().Add(5 * time.Minute)
	geoCacheLastUpdated.Set(float64(time.Now().Unix()))

	return geo, nil
}

func getGeoIP(ip string) (*GeoIP, error) {
	if ip == "::1" || ip == "127.0.0.1" || ip == "" || ip == "unknown" {
		return nil, fmt.Errorf("local or invalid IP")
	}

	token := os.Getenv("IPINFO_TOKEN")
	url := "https://ipinfo.io/" + ip + "?token=" + token

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	req, _ := http.NewRequestWithContext(ctx, "GET", url, nil)
	req.Header.Set("User-Agent", "Go-UpX-Demo/1.0")

	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("HTTP request failed: %v", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return nil, fmt.Errorf("non-200 status code: %d", resp.StatusCode)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	fmt.Fprintf(os.Stderr, "[DEBUG] HTTP Status Code: %d\n", resp.StatusCode)
	fmt.Fprintf(os.Stderr, "[DEBUG] Raw JSON Response:\n%s\n", body)

	var data map[string]interface{}
	err = json.Unmarshal(body, &data)
	if err != nil {
		return nil, fmt.Errorf("failed to parse JSON: %v", err)
	}

	if msg, ok := data["error"].(map[string]interface{}); ok {
		return nil, fmt.Errorf("ipinfo.io error: %v", msg)
	}

	if _, ok := data["bogon"]; ok {
		return nil, fmt.Errorf("bogon IP")
	}

	country, ok1 := data["country"].(string)
	region, ok2 := data["region"].(string)
	city, ok3 := data["city"].(string)
	org, ok4 := data["org"].(string)
	loc, ok5 := data["loc"].(string)
	timezone, ok6 := data["timezone"].(string)

	if !ok1 || !ok2 || !ok3 || !ok4 || !ok5 || !ok6 {
		return nil, fmt.Errorf("missing required fields in response")
	}

	coords := strings.Split(loc, ",")
	if len(coords) < 2 {
		return nil, fmt.Errorf("invalid coordinates format")
	}

	lat, err1 := strconv.ParseFloat(coords[0], 64)
	lon, err2 := strconv.ParseFloat(coords[1], 64)
	if err1 != nil || err2 != nil {
		return nil, fmt.Errorf("failed to parse lat/lon: %v, %v", err1, err2)
	}

	geo := &GeoIP{
		Query:    ip,
		Country:  country,
		Region:   region,
		City:     city,
		Lat:      lat,
		Lon:      lon,
		Timezone: timezone,
		Org:      org,
	}

	return geo, nil
}

func monitorServerHealth(ctx context.Context) {
	ticker := time.NewTicker(10 * time.Second)
	defer ticker.Stop()

	for {
		select {
		case <-ticker.C:
			// If 10s don't take request - make 'down' status
			upxServerUp.Set(0)

		case <-ctx.Done():
			return
		}
	}
}

// Handlers
// Middleware metric collector
func instrumentHandler(name string, handler http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		upxServerUp.Set(1)
		start := time.Now()
		defer func() {
			elapsed := time.Since(start).Seconds()

			httpRequestsTotal.WithLabelValues(name, r.Method).Inc()
			httpRequestLatency.WithLabelValues(name).Observe(elapsed)
		}()

		handler(w, r)
	}
}

func (s *Server) healthzHandler(w http.ResponseWriter, r *http.Request) {
	useJSON := false

	if r.Header.Get("Accept") == "application/json" || r.URL.Query().Get("format") == "json" {
		useJSON = true
	}

	resp := HealthResponse{Status: "ok"}
	sendHealthResponse(w, resp, useJSON, http.StatusOK)
}

func (s *Server) liveHandler(w http.ResponseWriter, r *http.Request) {
	if !hasInternetAccess() {
		sendHealthError(w, "no internet access", useJSONFromRequest(r))
		return
	}

	ip, err := getPublicIP()
	if err != nil {
		sendHealthError(w, "failed to fetch public IP", useJSONFromRequest(r))
		return
	}

	geo, err := s.getCachedGeo(ip)
	if err != nil {
		sendHealthError(w, "failed to fetch geolocation data", useJSONFromRequest(r))
		return
	}

	_ = geo

	sendHealthOK(w, useJSONFromRequest(r))
}

func (s *Server) locationHandler(w http.ResponseWriter, r *http.Request) {
	frame := gopherFrames[s.frameIndex%len(gopherFrames)]
	s.frameIndex++

	gopherLines := strings.Split(strings.TrimSuffix(frame, "\n"), "\n")
	maxLeftWidth := 0

	loc, err := time.LoadLocation("Europe/Moscow")
	if err != nil {
		log.Fatal("Failed to load location: ", err)
	}
	moscowTime := s.startTime.In(loc)
	currentTime := time.Now().In(loc)

	for _, line := range gopherLines {
		if visibleLength(line) > maxLeftWidth {
			maxLeftWidth = visibleLength(line)
		}
	}

	rightLines := []string{
		"",
		centerText(fmt.Sprintf("%s Welcome to the bloated Golang server!%s", cyan, reset), 30),
		"",
	}

	if hasInternetAccess() {
		hostIP, err := getPublicIP()
		if err != nil {
			log.Printf(" [!] Public IP not found: %v\n", err)
		} else {
			log.Printf(" [+] Public IP: %s\n", hostIP)
		}

		rightLines = append(rightLines,
			fmt.Sprintf(" [+] Server IP: %s%s%s", yellow, hostIP, reset),
		)

		geo, err := s.getCachedGeo(hostIP)

		if err == nil && geo != nil {
			rightLines = append(rightLines,
				fmt.Sprintf(" [+] Country:   %s%s%s", yellow, geo.Country, reset),
				fmt.Sprintf(" [+] Region:    %s%s%s", yellow, geo.Region, reset),
				fmt.Sprintf(" [+] City:      %s%s%s", yellow, geo.City, reset),
				fmt.Sprintf(" [+] ISP:       %s%s%s", yellow, geo.Org, reset),
				fmt.Sprintf(" [+] Lat/Lon:   %s%.4f, %.4f%s", yellow, geo.Lat, geo.Lon, reset),
				fmt.Sprintf(" [+] Timezone:  %s%s%s", yellow, geo.Timezone, reset),
			)
		} else {
			rightLines = append(rightLines,
				fmt.Sprintf("%s [-] Failed to fetch geo info for this IP%s", red, reset),
			)
		}
	} else {
		rightLines = append(rightLines,
			fmt.Sprintf("%s [-] No internet access — skipping external data%s", red, reset),
		)
	}

	rightLines = append(rightLines,
		"",
		fmt.Sprintf(" Server started at: %s%s%s", green, moscowTime.Format(time.UnixDate), reset),
		fmt.Sprintf(" Current time:      %s%s%s", green, currentTime.Format(time.UnixDate), reset),
	)

	for len(gopherLines) < len(rightLines) {
		gopherLines = append(gopherLines, "")
	}
	for len(rightLines) < len(gopherLines) {
		rightLines = append(rightLines, "")
	}

	var outputLines []string
	for i := 0; i < len(gopherLines); i++ {
		outputLines = append(outputLines, gopherLines[i]+alignRight(rightLines[i], maxLeftWidth-visibleLength(gopherLines[i])))
	}

	w.Header().Set("Content-Type", "text/plain; charset=utf-8")
	fmt.Fprintln(w, strings.Join(outputLines, "\n"))
}

func (s *Server) versionHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/plain")
	fmt.Fprintf(w, "Golang UPX Demo v%s\n", AppVersion)
}

func (s *Server) asciiArtStreamHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/event-stream")
	w.Header().Set("Cache-Control", "no-cache")
	w.Header().Set("Connection", "keep-alive")

	clientGone := r.Context().Done()

	ticker := time.NewTicker(1 * time.Second)
	defer ticker.Stop()

	frameIndex := 0
	start := time.Now()

	for {
		select {
		case <-ticker.C:
			frame := gopherFrames[frameIndex%len(gopherFrames)]
			frameIndex++

			msg := fmt.Sprintf("%s\n\nUptime: %.0fs\n", strings.TrimSuffix(frame, "\n"), time.Since(start).Seconds())

			fmt.Fprint(w, msg)
			if f, ok := w.(http.Flusher); ok {
				f.Flush()
			}

		case <-clientGone:
			return
		}
	}
}

// Heavy allocations to increase binary size
func heavyFunc() {
	buf := bytes.NewBuffer(nil)
	zw := zip.NewWriter(buf)
	defer zw.Close()

	_, _ = zw.Create("dummy.txt")
	_, _ = gzip.NewReader(bytes.NewReader([]byte{}))
	_, _ = aes.NewCipher(make([]byte, 32))
	_ = runtime.GOMAXPROCS(0)
	_ = image.Black.Bounds()
	_ = bufio.NewReader(os.Stdin)
	net.ParseIP("127.0.0.1")
}

// Entrypoint
func main() {
	token := os.Getenv("IPINFO_TOKEN")
	if token == "" {
		log.Fatal("Error: IPINFO_TOKEN not set or empty")
	}

	heavyFunc()

	server := &Server{
		startTime: time.Now(),
	}

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	http.HandleFunc("/", instrumentHandler("root", server.versionHandler))
	http.HandleFunc("/location", instrumentHandler("location", server.locationHandler))
	http.HandleFunc("/stream", instrumentHandler("stream", server.asciiArtStreamHandler))
	http.HandleFunc("/healthz", instrumentHandler("healthz", server.healthzHandler))
	http.HandleFunc("/live", instrumentHandler("live", server.liveHandler))
	http.Handle("/metrics", promhttp.Handler())

	go monitorServerHealth(ctx)

	fmt.Println("Starting HTTP server on :8080...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
