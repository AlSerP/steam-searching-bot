sudo du -h $(docker inspect --format='{{.LogPath}}' $(docker ps -qa))
