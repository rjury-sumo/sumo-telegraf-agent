# sumo-telegraf-agent
The sumo-telegraf-container is a containerised telegraf agent with built in sumologic metrics output plugin that sends metrics to a Sumo Logic HTTPS endpoint. 

It provides an easy to deploy and configure collection for use cases such as local Synthetic HTTP checks which can be deployed in minutes, to integrate telegraf collection into Sumo Logic.

The container image is pre-built and ready to use at:
https://hub.docker.com/repository/docker/rickjury/sumo-telegraf-agent/general

```
docker pull rickjury/sumo-telegraf-agent:latest
```

For implementation options see the docs pages below. Some pages have links to dashboard apps or terraform monitor configurations:
- [ping](docs/ping.md) - synthetic ping check
- [http_response](docs/http_response.md) - synthetic http check
- [statsd](docs/statsd.md) - recieve and forward statsd or dogstatsd metrics to Sumo Logic.

By default the container runs using the conf files in the ./conf folder. The files:
- Use env vars to make launch configurable through docker orchestration environment
- Include global tags for metadata in sumo such as sourcecategory
- Provide enterprise ready tags for dimensions such as: environment, location, service.
- Are filtered with fieldpass to provide sensible minimised DPM.

## global tags
Extra global tags are added in each conf file to enrich metric data posted to Sumo Logic as below, and these have values usually set in entrypoint.sh:
```
_sourcecategory=metrics/telegraf
_sourcehost=<container hostname>
ip=<container ip address>
component=<component name>
```

If you are looking to customize the container refer to the [output_plugin](./docs/output_plugin.md) doc.

## Configure Hosted Collector and HTTP Source
In order to send data to Sumo Logic with Telegraf’s Sumo Logic output plugin you need to create a Hosted Collector with an HTTP Source to ingest the data. For instructions see:
- [Configure a Hosted Collector](https://help.sumologic.com/03Send-Data/Hosted-Collectors/Configure-a-Hosted-Collector)
- [HTTP Logs and Metrics Source](https://help.sumologic.com/03Send-Data/Sources/02Sources-for-Hosted-Collectors/HTTP-Source)


These topics have detailed overview of: 
- [Sumo Logic's metric output plugin for telegraf](https://help.sumologic.com/03Send-Data/Collect-from-Other-Data-Sources/Collect_Metrics_Using_Telegraf/05_Configure_Telegraf_Output_Plugin_for_Sumo_Logic)
- [Sumo Logic Telegraf Collection Architecture](https://help.sumologic.com/03Send-Data/Collect-from-Other-Data-Sources/Collect_Metrics_Using_Telegraf) 

## How To Execute the Container
For examples to orchestrate container see: [orchestration](./orchestration)

Execute the container with a SUMO_URL endpoint variable and other optinal environment variable tags for environment, location and service:

```
docker run -it -e SUMO_URL="$SUMO_URL"  -e env=prod -e urls='http://sumologic.com,https://support.sumologic.com' -e location=living_room -e service=myservice rickjury/sumo-telegraf-agent telegraf --config http_response.conf
```

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

## Environment Variables
Set the mandatory envrionment variable SUMO_URL with the https endpoint address for your HTTPS endpoint from above.

There are other environment variables that can be set to customise the tag dimensions sent.

Refer to this doc for details on the environment [variables](./docs/env_vars.md) that can be set for the container. 

### ports
Some plugins require a port such as statsd most are outbound only. In this case start the container with a port mapping for example:
```
docker run -it -p 8125:8125/udp -e SUMO_URL="$SUMO_URL"  -e env=prod -e location=dc1 -e service myservice rickjury/sumo-telegraf-agent telegraf  --config statsd.conf
```



