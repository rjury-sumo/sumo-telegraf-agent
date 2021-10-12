# output plugin configuration
The output plugin has some custom dimensions added in the conf file.

Most of these are set with a default value in entrypoint.sh


| Field          | Value            | Configuration Example                                                                                                                    |
|----------------|------------------|------------------------------------------------------------------------------------------------------------------------------------------|
| url            | HTTPS endpoint   | The https endpoint to send metric data to at Sumo Logic. url = "https://events.sumologic.net/receiver/v1/http/<UniqueHTTPCollectorCode>" |
| sourcecategory | metrics/telegraf |   source_category = "metrics/telegraf"                                                                                                   |
| data_format    | prometheus       |   data_format = "prometheus"                                                                                                             |
| source_host    | hostname         |   source_host = "${HOSTNAME}"                                                                                                            |
|       x-sumo-fields         |      ignore=me           |        Sets the x-sumo-fields header on post to Sumo Logic.          