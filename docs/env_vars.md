# env vars
Runtime container variables allow you to run container instances with custom config set in the orchestration environment.
Default values for env vars are defined in entrypoint.sh


| variable       | mandatory | notes                                                                                                                                                                                                                          |   |
|----------------|-----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---|
| SUMO_URL       | yes       | The https endpoint to send metric data to at Sumo Logic.  You must provide a valid SUMO_URL environment variable to execute the container. This should be the HTTPS metrics endpoint source you have configured in Sumo Logic. |   |
| env            | no        | The environment that the tests apply to. Sets the environment tag on the input plugin.                                                                                                                                         |   |
| location       | no        | The location that the test runs. Sets a tag on the input plugin.                                                                                                                                                               |   |
| service        | no        | The service that the check relates to. Sets a tag on the input plugin.                                                                                                                                                         |   |
| urls           | yes       | One or more urls to check as either a single address or a csv list of addresses.                                                                                                                                               |   |
| interval       | no        | Check interval defaults to 60s                                                                                                                                                                                                 |   |
| flush_interval | no        | Flush interval for output plugin defaults to 60s. More frequent intervals will increase DPM.    

