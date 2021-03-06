package main

import (
	"os"
	"strings"

	"github.com/gofiber/fiber"
	"github.com/gofiber/logger"
)

var version string

func main() {
	app := fiber.New()

	app.Use(logger.New())

	app.Get("/", func(c *fiber.Ctx) {
		result := GetEnv()

		c.JSON(result)
	})

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

// GetEnv getEnv
func GetEnv() map[string]string {
	result := make(map[string]string)

	nodeName := os.Getenv("NODE_NAME")
	podName := os.Getenv("POD_NAME")

	result["API_VERSION"] = version
	result["NODE_NAME"] = nodeName
	result["POD_NAME"] = podName

	return result
}

// GetPodEnv getPodEnv
func GetPodEnv() map[string]string {
	env := os.Environ()

	result := make(map[string]string)

	for _, e := range env {
		pair := strings.SplitN(e, "=", 2)

		result[pair[0]] = pair[1]
	}

	return result
}
