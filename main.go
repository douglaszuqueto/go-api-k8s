package main

import (
	"os"
	"strings"

	"github.com/gofiber/fiber"
	"github.com/gofiber/logger"
)

const version = "v1.0.0"

func main() {
	app := fiber.New()

	app.Use(logger.New())

	app.Get("/ping", func(c *fiber.Ctx) {
		c.Send("pong")
	})

	app.Get("/info", func(c *fiber.Ctx) {
		result := GetEnv()

		c.JSON(result)
	})

	app.Get("/env", func(c *fiber.Ctx) {
		result := GetPodEnv()

		c.JSON(result)
	})

	app.Listen(4000)
}

// GetEnv GetEnv
func GetEnv() map[string]string {
	result := make(map[string]string)

	nodeName := os.Getenv("NODE_NAME")
	podName := os.Getenv("POD_NAME")
	hostname, _ := os.Hostname()

	result["API_VERSION"] = version
	result["NODE_NAME"] = nodeName
	result["POD_NAME"] = podName
	result["HOSTNAME"] = hostname

	return result
}

// GetPodEnv GetPodEnv
func GetPodEnv() map[string]string {
	env := os.Environ()

	result := make(map[string]string)

	for _, e := range env {
		pair := strings.SplitN(e, "=", 2)

		result[pair[0]] = pair[1]
	}

	return result
}
