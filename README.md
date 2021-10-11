# sumo-telegraf-agent
A containerised telegraf agent with built in sumologic metrics output.
Source for: rickjury/sumo-telegraf-agent on docker hub.

```
docker pull rickjury/sumo-telegraf-agent:latest
```

Project provides easy to launch synthetic & other monitors that send SumoLogic output plugin metrics using the telegraf input plugins for:
- [ping](docs/ping.md)
- [http_response](docs/http_response.md)
- [statsd](docs/statsd.md)

Plugin conf files can be found in ./conf. The files:
- use env vars to make launch configurable through docker orchestration environment
- Include global tags for metadata in sumo such as sourcecategory
- Provide enterprise ready tags for dimensions such as: env, location, service.
- Are filtered with fieldpass to provide sensible minimised DPM

### docker hub
Container image ready to use at:
https://hub.docker.com/repository/docker/rickjury/sumo-telegraf-agent/general

for example:


## setup and run
```
docker run -it -e SUMO_URL="$SUMO_URL"  -e env=prod -e urls='http://sumologic.com,https://support.sumologic.com' -e location=living_room rickjury/sumo-telegraf-agent telegraf --config http_response.conf
```
Make sure when you execute the container you have a valid conf file: you can use one of the conf's in the container or provide your own custom one.

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

