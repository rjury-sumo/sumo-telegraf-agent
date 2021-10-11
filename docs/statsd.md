# statsd 
```
component=statsd
```
Listens for statsd or datatog statsd metrics on UDP 8125 and forwards in prometheus format to sumo.
https://github.com/influxdata/telegraf/tree/master/plugins/inputs/statsd

**You must expose UDP 8125 or the container will fail to start**

To start the container:
```
docker run -it -p 8125:8125/udp -e SUMO_URL="$SUMO_URL"  -e env=prod -e location=dc1 rickjury/sumo-telegraf-agent telegraf  --config statsd.conf
```

To test metrics is working:
- open shell in the running container.
```
echo -n "custom_metric:60|g|#shell" >/dev/udp/localhost/8125
```
- metrics would be visible in sumo with: component=statsd metric=custom_metric_value 

## env vars
See: [env_vars.md](env_vars.md)












