# sumo-telegraf-agent
A containerised telegraf agent with built in sumologic metrics output.
Source for: rickjury/sumo-telegraf-agent on docker hub.

Project provides easy to launch synthetic & other monitors that send SumoLogic output plugin metrics using the telegraf input plugins for:
- [ping](docs/ping.md)
- [http_response](docs/http_response.md)
- [statsd](docs/statsd.md)

In this project we will also include example telegraf.conf files in 1.19/conf with env vars to make configuration launch more dynamic so it's ready to go in an enterprise environment.

Custom tagging dimensions are built in for things like:
- sourcecategory
- env
- location
- service

### docker hub
Container image ready to use at:
https://hub.docker.com/repository/docker/rickjury/sumo-telegraf-agent/general

for example:
```
docker run -it -e SUMO_URL="$SUMO_URL"  -e env=prod -e urls='http://sumologic.com,https://support.sumologic.com' -e location=living_room rickjury/sumo-telegraf-agent telegraf --config http_response.conf
```

## setup and run
Make sure when you execute the container you have a valid conf file.
You can use one of the conf's in the container or provide your own custom one.

The built in files have various environment [variables](./docs/env_vars.md), only a few of which are mandatory - such as SUMO_URL. Defaults are set in entrypoint.sh.

Some plugins require a port such as statsd most are outbound only.

For examples to orchestrate container see: docker/orchestration

Docker compose example of a http synthetic check vs two web urls.
```
version: "3"  
services:
  http_response_checks:
    image: rickjury/sumo-telegraf-agent
    container_name: http_check_sumologic1
    hostname: http_check_sumologic1
    command: [ "telegraf","--config","http_response.conf"]
    environment:
      SUMO_URL: "${SUMO_URL}"
      env: "test"
      location: "mymac-compose"
      service: demo_dc
      urls: http://sumologic.com,https://help.sumologic.com
```

## global tags
Posts to sumo with following global tags on all metrics that appear in sumo as metric dimensions:
```
_sourcecategory=metrics/telegraf
_sourcehost=<container hostname>
ip=<container ip address>
component=<component name>
```

