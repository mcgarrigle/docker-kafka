# Kafka

This project maintains the development image for Kafka

The image contains:
* Kafka     2.1.1
* Zookeeper 2.1.1

When the image is run, internal application TCP ports are mapped to ephemeral
host ports and each application is started.
```
+-----------------------------------------+
| Virtual Machine (vm.foo.com)            |
|                                         |
|   +---------------------------------+   |
|   | Container  (8de05600b948)       |   |
|   |                                 |   |
|   |    +-------------------------+  |   |
|   |    |       Kafka             |  |   |
|   |    |       localhost:9092    |  |   |
|   |    |                         |  |   |
|   |    +-------------------------+  |   |
|   |                                 |   |
|   |    +-------------------------+  |   |
|   |    |       Zookeeper         |  |   |
|   |    |       localhost:2181    |  |   |
|   |    |                         |  |   |
|   |    +-------------------------+  |   |
|   |                                 |   |
|   +---------------------------------+   |
|                                         |
+-----------------------------------------+
```
## Docker Image Build
```
$ ./assets.sh
$ docker build --tag kafka:latest .
```
## Test
```
$ docker run -it --network=host edenhill/kafkacat:1.6.0 -b localhost:29092 -L
```
