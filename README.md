# mongooseim-docker

MongooseIM server version 1.5.  

MongooseIM is Erlang Solutions' robust and efficient XMPP server aimed at large installations. Specifically designed for enterprise purposes, it is fault-tolerant, can utilize resources of multiple clustered machines and easily scale in need of more capacity (by just adding a box/VM). It provides support for WebSockets and reimplemented BOSH.

Its home at GitHub is http://github.com/esl/MongooseIM.

## Usage 

### Run in foreground

`$ docker run -i -t  mongooseim/mongooseim-docker`

### Run in background

`$ docker run -d   mongooseim/mongooseim-docker`

## Exposed ports
* 5222 
* 5280 
* 5269
