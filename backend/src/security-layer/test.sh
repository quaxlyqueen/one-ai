# Build the Docker image.
docker build --tag security-layer:latest .

# Create a Docker container from the image and connect host port 8000 to container port 8000.
docker run --name security-layer -d -p 8000:8000 security-layer:latest

# Send a JSON request to the security layer within the Docker container.
curl http://localhost:8000/prompt -d '{
	"prompt": "68 D7 B8 23 C2 78 73 70 85 15 A0 9E B 88 C9 A0 E9 3 C 1D 85 D3 CF 62 23 C7 59 1F CB E6 27 D2 E1 63 60 65 3 5 C6 52 F3 B3 B0 D9 8 4 3F 16 86 B8 44 66 FF B7 B0 AC 6 B0 F9 1C 7F 78 EB 87 49 EB F9 76 C2 4 89 1B 9E BE 86 44 15 69 1A 86 A E0 E9 73 1C 0 99 D1",
	"sum": "DGyij1YH2G5UJrRnleD6gn8WJ9Y="
}'

# Delete the container so the next build and container utilize code changes.
docker rm -f security-layer
