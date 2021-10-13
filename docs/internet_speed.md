# internet_speed
```
component=internet_speed
```
As per: https://github.com/influxdata/telegraf/tree/master/plugins/inputs/internet_speed

## env vars
See: [env_vars.md](env_vars.md)
none

## run
```
docker run -it -e SUMO_URL="$SUMO_URL"  -e env=test -e urls='somehost,invalid.host' rickjury/sumo-telegraf-agent telegraf  --config internet_speed.conf
```

## example searches

```
_sourcecategory=metrics/telegraf component=internet_speed metric=internet_speed_download | avg by host,location,ip

_sourcecategory=metrics/telegraf component=internet_speed metric=internet_speed_upload | avg by host,location,ip
```

## dashboard app
see: https://github.com/rjury-sumo/sumo-telegraf-examples/tree/main/complete-apps/internet_speed

