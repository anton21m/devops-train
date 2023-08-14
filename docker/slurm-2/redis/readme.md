docker run --name redis --rm -v ./data:/data/ -d redis

docker exec -it redis bash

redis-cli
    set mykey foobar установить ключ
    get mykey получить ключ
    save скинуть в dump

