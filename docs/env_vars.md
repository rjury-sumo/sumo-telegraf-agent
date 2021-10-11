# env vars
Runtime container variables allow you to run potentially  container instances with custom config.
Default values for env vars are defined in entrypoint.sh

## Env vars mandatory 
- SUMO_URL 

## env vars optional
This container is designed to send some extra contextual information with the default metric dimensions.

Typically with synthetic checks we would want to add additional dimensions such as:
- X_SUMO_FIELDS: any arbitrary commas separated list of fields.
- env: sends a tag called environment to sumo
- service: the service name for grouping endpoints
- location: the location the dockerised test is run from. Useful if you want to test from multiple source locations.
- interval and flush_interval: default to 60s.
