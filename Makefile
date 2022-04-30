
.PHONY: all

all:
	docker compose build

run:
	docker compose up

clean: clean_proto
	docker-compose rm -f -s

car: clean all run

dev: all generate_proto run

PROTO_DOCKER_IMAGE=habits_go_build
generate_proto: clean_proto
	docker build -f ./backend/build.Dockerfile -t $(PROTO_DOCKER_IMAGE):latest ./backend/
	docker run --name habits_go_build -v G:\Projects\Habits/backend/proto:/usr/src/app/mounted_proto $(PROTO_DOCKER_IMAGE):latest  /bin/bash -c "cp proto/*.pb.go mounted_proto/"

clean_proto:
	@docker stop $(PROTO_DOCKER_IMAGE) || echo No container to stop
	@docker rm $(PROTO_DOCKER_IMAGE) || echo No container to remove
	@del /f /s /q backend\proto\*.pb.go || echo No files to delete