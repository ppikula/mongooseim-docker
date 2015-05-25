# mongooseim-docker

MongooseIM server stable version (to change it edit Dockerfile  MONGOOSEIM\_VERSION
and build a new image)

MongooseIM is Erlang Solutions' robust and efficient XMPP server aimed at large installations. Specifically designed for enterprise purposes, it is fault-tolerant, can utilize resources of multiple clustered machines and easily scale in need of more capacity (by just adding a box/VM). It provides support for WebSockets and reimplemented BOSH.

Its home at GitHub is http://github.com/esl/MongooseIM.

## Usage

### Start single node

To start interavtive session:

`$ docker run -i -t  mongooseim/mongooseim-docker live`

To start mongooseim in the background, logs will be available via `docker logs`

`$ docker run -d -t  mongooseim/mongooseim-docker`

Note that there is the `-t` option, without it the `mongooseim debug` shell won't
work if you try to start it with docker exec

To attach debug shell to already running node

`$ docker exec -it CONTAINER_NAME mongooseimctl debug`

Moreover with the `docker exec` command you can do any mongoosectl command for example
register a new user:

`$ docker exec -it CONTAINER_NAME mongooseimctl mongooseimctl register pawel localhost test`


### Create cluster mongooseim nodes

To be able to create a mongooseim cluster you need to specify hostname for
the containers. Based on hostname the `start.sh` script will start a node with
the following sname `mongooseim@hostname`.

To start cluster you need to start initial node:

`$ docker run -d -t -h mim1 --name mim1 mongooseim/mongooseim-docker `

sname of initial node will be `mongooseim@mim1`. To start the next node and make
it part of existing cluster you need to add link option and set `CLUSTER_WITH`
env variable.

`$ docker run -d -t -h mim2 --name mim2 --link mim1:mim1 -e CLUSTER_WITH=mim1 mongooseim/mongooseim-docker `

We started a new node with sname: `mognooseim@mim2` which will join the cluster
to which mim1 does belong. Note that link name and CLUSTER_WITH *must* match
the hostname of initial node. It wouldn't work if set in the following way:
`--link mim1:my_initial_node` and `-e CLUSTER_WITH=my_initial_node_name`.

### Change config file

// cp from image
// modify

## Other versions

For different versions of the mongooseim docker images check the tags tab:
https://registry.hub.docker.com/u/mongooseim/mongooseim-docker/tags/manage/

In case you need different version you have to edit Dockerfile and change `MONGOOSEIM_VERSION`
to desired branch/tag and then build a new image.

## Volumes

There are two volumes that one might want to persist or share between image upgrades:

* `/data/log` - mongooseim logs directory (logs are also available through `docker logs CONTAINER_NAME`
* `/data/mnesia` - mnesia dir

To bind a volume use -v option:

`docker run -td -h mim1 -v `pwd`/mnesia:/data/mnesia -v `pwd`/log:/data/log --name mim1 mongooseim/mongooseim-docker`

It will start a MongooseIM instance and it will bind the mnesia dir and log directory
to the `mnesia` and `log` dir in the current working dir.

The mnesia directory would look like this:

```
ls -l mnesia
total 0
drwxr-xr-x  16 pawel.pikula  staff  544 May 25 16:05 Mnesia.mongooseim@mim1
drwxr-xr-x  16 pawel.pikula  staff  544 May 25 16:05 Mnesia.mongooseim@mim2
```

In the result, it is possible to use one volume for all instances but in case of
log directory, the log files are saved directly in that directory:

```
ls -la log
total 8
drwxr-xr-x   4 pawel.pikula  staff  136 May 25 16:02 .
drwxr-xr-x  10 pawel.pikula  staff  340 May 25 08:38 ..
-rw-r--r--   1 pawel.pikula  staff    0 May 25 16:02 crash.log
-rw-r--r--   1 pawel.pikula  staff  472 May 25 16:02 ejabberd.log
```

## Exposed ports

* 4369 - epmd - erlang port mapper daemon
* 5222 - xmpp port
* 5280 - rest endpoint
* 5269 - port for the s2s communication
* 9100 - port for distributed erlang
